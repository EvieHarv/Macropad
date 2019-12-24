using System;
using System.Collections.Generic;
using System.IO.Pipes;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Colore;
using Colore.Data;
using Colore.Effects.Keyboard;
using ColoreColor = Colore.Data.Color;
using System.IO;
using System.Net.Sockets;
using System.Net;

namespace RazerColour // THIS ENTIRE PROGRAM NEEDS REWORKING. ITS CURRENT STATE WAS A QUICK AND DIRTY JOB TO GET IT TO WORK.
{
    class Program
    {
        public static KeyboardCustom currentKeyboard = KeyboardCustom.Create();
        public static Mutex mutex = null;

        static void Main(string[] args) // Args - [Filepath - Relative to "C:\ProgramData\ZRazer\Lightpacks\" or absolute.]
        {
            AppCall callArgs = new AppCall(args);
            // Create a mutex to confirm it is the only existing process of its type.
            mutex = new Mutex(true, "RazerColor", out bool createdNew);

            // If its not created new, send its message to the main client.
            if (!createdNew)
            {
                string str = string.Join(":", args); // Combine the args back together
                StartInternalClient(str); // Send it off to the client server
                return;
            }

            // Fetch a chroma interface
            IChroma chromaInstance = GetInstance().Result;

            bool state = SwitchColour(callArgs, chromaInstance).Result;

            while (state)
            {
                Console.WriteLine("Starting a new server connection...");

                string incomingData = StartInternalServer();
                state = SwitchColour(new AppCall(incomingData.Split(':')), chromaInstance).Result; // End program if it didn't work
            };

            Error(chromaInstance).Wait();
        }


        static async Task<bool> SwitchColour(AppCall args, IChroma chroma)
        {
            if (args.invalid) return false;

            var grid = KeyboardCustom.Create();

            if (args.addWeak || args.addStrong) grid = currentKeyboard;

            ColoreColor clr = ColoreColor.Black;

            foreach (string fline in File.ReadLines(args.filePath))
            {
                string line = fline;
                if (line.Contains(";")) line = line.Substring(0, line.IndexOf(";"));
                line = line.Trim();
                if (line == "") continue;


                if (line.ToLower().StartsWith("rgb"))
                {
                    var b = line.Remove(0, 3).Trim();

                    try
                    {
                        clr = ColoreColor.FromRgb(uint.Parse(b, System.Globalization.NumberStyles.HexNumber));
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("yo your color was invalid dude");
                        Console.WriteLine(e);
                        return false;
                    }
                }

                if (line.ToLower().StartsWith("all")) { grid.Set(clr); }

                if (!Enum.TryParse(line, true, out Key currKey) && !line.ToLower().StartsWith("rgb") && !line.ToLower().StartsWith("all")) // horrible code hours
                {
                    Console.WriteLine("thats not a valid key pls fix");
                    Console.WriteLine(currKey.ToString());
                    return false;
                }


                if (args.addWeak)
                {
                    if (grid[currKey] == ColoreColor.Black) { grid[currKey] = clr; }
                }
                else
                {
                    grid[currKey] = clr;
                }
            }

            currentKeyboard = grid;
            Console.WriteLine("bro");
            await chroma.Keyboard.SetCustomAsync(grid);
            return true;
        }
        static string StartInternalServer() // start the local server as host
        {
            try
            {
                IPAddress ipAd = IPAddress.Parse("127.0.0.1");

                /* Initializes the Listener */
                TcpListener myList = new TcpListener(ipAd, 4496);

                /* Start Listeneting on port */
                myList.Start();

                Console.WriteLine("The server is running at port 4496...");
                Console.WriteLine("The local End point is: " +
                                  myList.LocalEndpoint);
                Console.WriteLine("Waiting for a connection.....");

                // accept incoming connection
                Socket s = myList.AcceptSocket();
                Console.WriteLine("Connection accepted from " + s.RemoteEndPoint);

                // decode the recieved data
                byte[] b = new byte[260];
                int k = s.Receive(b);
                Console.WriteLine("Recieved...");
                string result = "";
                for (int i = 0; i < k; i++)
                {
                    result = result + Convert.ToChar(b[i]);
                    Console.Write(Convert.ToChar(b[i]));
                }


                /* clean up */
                s.Close();
                myList.Stop();
                Console.WriteLine("");
                return result;
            }
            catch (Exception e)
            {
                Console.WriteLine("Error..... " + e.StackTrace);
                return "";
            }
        }
        static void StartInternalClient(string str) // Connect to internal server and send message.
        {
            try
            {
                // tcp protocoll handler
                TcpClient tcpclnt = new TcpClient();
                Console.WriteLine("Connecting.....");

                // local server on port 4496
                tcpclnt.Connect("127.0.0.1", 4496);

                Console.WriteLine("Connected");

                // get the socket stream
                Stream stm = tcpclnt.GetStream();

                // encode the data
                ASCIIEncoding asen = new ASCIIEncoding();
                byte[] ba = asen.GetBytes(str);
                Console.WriteLine("Transmitting.....");

                // send the data
                stm.Write(ba, 0, ba.Length);

                // close the connection
                tcpclnt.Close();
            }

            catch (Exception e)
            {
                Console.WriteLine("Error..... " + e.StackTrace);
            }
        }
        
        static async Task<IChroma> GetInstance()
        {
            Console.WriteLine("Creating a new chroma instance...");
            var chroma = await ColoreProvider.CreateNativeAsync();
            await Task.Delay(1000); // Used to be 500, but apparently the razer API got slower or something. 
            return chroma;
        }
        static async Task Error(IChroma chroma) // Flashes entire keyboard red.
        {
            for (int i = 0; i < 4; i++)
            {
                await chroma.Keyboard.SetAllAsync(ColoreColor.Red);
                await Task.Delay(250);
                await chroma.Keyboard.SetAllAsync(ColoreColor.Black);
                await Task.Delay(250);
            }
            await chroma.SetAllAsync(ColoreColor.Red);
            await Task.Delay(1500);
            return;
        }
    }
}