using UnityEngine;
using System.Collections;

public class SetUILight : MonoBehaviour {

	// Use this for initialization
	void Awake () {
        UITools.gLightCanvas = transform;
        Transform t = transform.parent.FindChild("Camera_UI");
        UITools.gLightCamera = t.GetComponent<Camera>();
    }
	
	
}
