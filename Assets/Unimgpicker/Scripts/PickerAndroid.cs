#if UNITY_ANDROID
using UnityEngine;

namespace Zhenyi
{
    internal class PickerAndroid : IPicker
    {
        private static readonly string PickerClass = "com.kakeragames.unimgpicker.Picker";

        public void Show(string title, string outputFileName, int maxSize)
        {
			Debug.Log("[hehe] android");
            //using (var picker = new AndroidJavaClass(PickerClass))
            //{
            //    picker.CallStatic("show", title, outputFileName, maxSize);
            //}
        }
    }
}
#endif