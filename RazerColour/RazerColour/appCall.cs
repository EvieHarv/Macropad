using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RazerColour
{
    class AppCall
    {
        public string filePath;

        public bool addStrong;
        public bool addWeak;

        public bool invalid;

        public AppCall(string[] args) // Not a good parser, but its a parser that works in this case.
        {
            if (args.Contains("-a")) addWeak = true;
            if (args.Contains("-A")) addStrong = true;

            if (addWeak && addStrong) invalid = true; // If both addWeak and addStrong are included, something is wrong

            string argTemp = "";
            int i = 0; // Make sure we only have one argument for file

            foreach (string arg in args)
            {
                if (!arg.StartsWith("-")) { argTemp = arg; i++; }
            }

            if (i != 1) invalid = true; // If !(1 arg), invalid.


            filePath = RetrievePath(argTemp);
            if (filePath == null) invalid = true;
        }

        private static string RetrievePath(string filePath)
        {
            if (File.Exists(filePath)) return filePath;
            else if (File.Exists(@"C:\ProgramData\ZRazer\Lightpacks\" + filePath)) return @"C:\ProgramData\ZRazer\Lightpacks\" + filePath;
            else if (File.Exists(@"C:\ProgramData\ZRazer\Lightpacks\" + filePath + ".rzl")) return @"C:\ProgramData\ZRazer\Lightpacks\" + filePath + ".rzl";
            else return null;
        }

    }
}
