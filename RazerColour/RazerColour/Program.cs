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
        private static Mutex mutex = null;

        static void Main(string[] args) // Args - [Filepath - Relative to "C:\ProgramData\ZRazer\Lightpacks\" or absolute.]
        {
            bool createdNew;
            mutex = new Mutex(true, "RazerColor", out createdNew);
            if (!createdNew)
            {
                StartInternalClient(args[0]);
                return;
            }
            IChroma chroma = GetInstance().Result;
            bool state = SwitchColour(args[0], chroma).Result;
            while (state)
            {
                Console.WriteLine("Starting new server...");
                string newColour = StartInternalServer();
                bool worked = SwitchColour(newColour, chroma).Result; // End program if it didn't work
                if (!worked) break;
            };
            bool asyncHack1 = Error(chroma).Result;
        }

        static async Task<bool> Error(IChroma chroma) // Flashes entire keyboard red.
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
            return false;
        }

        static async Task<IChroma> GetInstance()
        {
            var chroma = await ColoreProvider.CreateNativeAsync();
            await Task.Delay(500);
            return chroma;
        }
        static async Task<bool> SwitchColour(string filePath, IChroma chroma)
        {
            if (!File.Exists(filePath)) // Future ethan checking in - what did this do exactly? As stated above, need to redo this entire thing...
            {
                if (File.Exists(@"C:\ProgramData\ZRazer\Lightpacks\" + filePath)) filePath = @"C:\ProgramData\ZRazer\Lightpacks\" + filePath;
                else if (File.Exists(@"C:\ProgramData\ZRazer\Lightpacks\" + filePath + ".rzl")) filePath = @"C:\ProgramData\ZRazer\Lightpacks\" + filePath + ".rzl";
                else return false;
            }


            var grid = KeyboardCustom.Create();

            ColoreColor clr = ColoreColor.Black;

            foreach (string fline in File.ReadLines(filePath))
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

                if (!Enum.TryParse(line, true, out Key result) && !line.ToLower().StartsWith("rgb"))
                {
                    Console.WriteLine("thats not a valid key pls fix");
                    Console.WriteLine(result.ToString());
                    return false;
                }

                grid[result] = clr;
            }


            await chroma.Keyboard.SetCustomAsync(grid);
            return true;
        }
        static string StartInternalServer()
        {
            try
            {
                IPAddress ipAd = IPAddress.Parse("127.0.0.1");
                // use local m/c IP address, and 
                // use the same in the client

                /* Initializes the Listener */
                TcpListener myList = new TcpListener(ipAd, 4496);

                /* Start Listeneting at the specified port */
                myList.Start();

                Console.WriteLine("The server is running at port 4496...");
                Console.WriteLine("The local End point is: " +
                                  myList.LocalEndpoint);
                Console.WriteLine("Waiting for a connection.....");

                Socket s = myList.AcceptSocket();
                Console.WriteLine("Connection accepted from " + s.RemoteEndPoint);

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
        static void StartInternalClient(string str)
        {
            try
            {
                TcpClient tcpclnt = new TcpClient();
                Console.WriteLine("Connecting.....");

                tcpclnt.Connect("127.0.0.1", 4496);
                // use the ipaddress as in the server program

                Console.WriteLine("Connected");

                Stream stm = tcpclnt.GetStream();

                ASCIIEncoding asen = new ASCIIEncoding();
                byte[] ba = asen.GetBytes(str);
                Console.WriteLine("Transmitting.....");

                stm.Write(ba, 0, ba.Length);

                tcpclnt.Close();
            }

            catch (Exception e)
            {
                Console.WriteLine("Error..... " + e.StackTrace);
            }
        }
    }
}