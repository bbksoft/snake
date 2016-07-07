using UnityEngine;
using System.Collections;

public class CameraCopy : MonoBehaviour {

	// Use this for initialization
	void Start () {
        Camera a = GetComponent<Camera>();
        a.CopyFrom(Camera.main);

        string[] layers = new string[1];
        layers[0] = "LightActor";
        a.cullingMask = LayerMask.GetMask(layers);
        a.clearFlags = CameraClearFlags.Depth;
        
    }

	// Update is called once per frame
	void Update () {

	}
}
