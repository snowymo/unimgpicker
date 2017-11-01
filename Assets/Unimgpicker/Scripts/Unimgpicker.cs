using UnityEngine;
using System.Collections;

namespace Zhenyi
{
    public class Unimgpicker : MonoBehaviour
    {
        public delegate void DocDelegate(string path);

        public delegate void ErrorDelegate(string message);

        public event DocDelegate Completed;

        public event ErrorDelegate Failed;

        private IPicker picker = 
        #if UNITY_IOS && !UNITY_EDITOR
            new PickeriOS();
        #elif UNITY_ANDROID && !UNITY_EDITOR
            new PickerAndroid();
		#elif UNITY_EDITOR_OSX || UNITY_EDITOR_WIN
			new Picker_editor();
        #else
            new PickerUnsupported();
        #endif

        public void Show(string title, string outputFileName, int maxSize)
        {
			//Debug.Log("in Unimgpicker.cs:Show()function");
			print("[hehe]in Unimgpicker.cs:Show()function");
            picker.Show(title, outputFileName, maxSize);
        }

        private void OnComplete(string path)
        {
            var handler = Completed;
            if (handler != null)
            {
                handler(path);
            }
        }

        private void OnFailure(string message)
        {
            var handler = Failed;
            if (handler != null)
            {
                handler(message);
            }
        }
    }
}