using UnityEngine;
using System.Collections;

namespace Zhenyi
{
    public class Rotator : MonoBehaviour
    {
        [SerializeField]
        private Vector3 rotationVector;

        void Update()
        {
            transform.Rotate(rotationVector * Time.deltaTime);
        }
    }
}