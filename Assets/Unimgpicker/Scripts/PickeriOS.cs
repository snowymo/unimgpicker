#if UNITY_IOS
using System.Runtime.InteropServices;

namespace Zhenyi
{
    internal class PickeriOS : IPicker
    {
        [DllImport("__Internal")]
		private static extern void Undocpicker_show(string title, string outputFileName, int maxSize);
        //private static extern void Unimgpicker_show(string title, string outputFileName, int maxSize);

        public void Show(string title, string outputFileName, int maxSize)
        {
			//Unimgpicker_show(title, outputFileName, maxSize);
			//Console.Log("in namespace Zhenyi: IPicker: Show()function");
            Undocpicker_show(title, outputFileName, maxSize);
        }
    }
}
#endif