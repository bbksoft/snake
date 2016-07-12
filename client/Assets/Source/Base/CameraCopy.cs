using UnityEngine;
using System.Collections;

public class CameraCopy : MonoBehaviour {

    public enum Type
    {
        main,
        ui
    }

    public Type mType;

    // Use this for initialization
    void Start () {
       
        Camera a = GetComponent<Camera>();
        float oldDepth = a.depth;

        if (mType == Type.main)
        {
            a.CopyFrom(Camera.main);
        }
        else
        {
            a.CopyFrom(UITools.gCam);
        }

        string[] layers = new string[1];
        layers[0] = "LightActor";
        a.cullingMask = LayerMask.GetMask(layers);
        a.clearFlags = CameraClearFlags.Depth;

        a.depth = oldDepth;
    }

	// Update is called once per frame
	void Update () {

	}
}
