using UnityEngine;
using System.Collections;

public class DrawRectLine : MonoBehaviour {

   
    public int size = 20;
    public int unitWidth = 2;
    public Material mat;

    Mesh mesh;

    // Use this for initialization
    void Start () {
        mesh = new Mesh();
       
        int count = size*size;

        Vector3[] vertices = new Vector3[count*4];
        Vector2[] UV = new Vector2[count*4];
        int[] triangles = new int[count * 6];

        for (int i = 0; i < size; i++)
        { 
            for (int j = 0; j < size; j++)
            {
                int pos = i + j * size;
                vertices[pos * 4 + 0] = new Vector3(i* unitWidth + 0, j* unitWidth + 0, 0);
                vertices[pos * 4 + 1] = new Vector3(i* unitWidth + 0, j* unitWidth + unitWidth, 0);
                vertices[pos * 4 + 2] = new Vector3(i* unitWidth + unitWidth, j* unitWidth + unitWidth, 0);
                vertices[pos * 4 + 3] = new Vector3(i* unitWidth + unitWidth, j* unitWidth + 0, 0);

                UV[pos * 4 + 0] = new Vector2(0, 0);
                UV[pos * 4 + 1] = new Vector2(0, 1);
                UV[pos * 4 + 2] = new Vector2(1, 1);
                UV[pos * 4 + 3] = new Vector2(1, 0);

                triangles[pos*6 + 0] = pos * 4 + 0;
                triangles[pos*6 + 1] = pos * 4 + 1;
                triangles[pos*6 + 2] = pos * 4 + 2;
                triangles[pos*6 + 3] = pos * 4 + 2;
                triangles[pos*6 + 4] = pos * 4 + 3;
                triangles[pos*6 + 5] = pos * 4 + 0;
            }
        }

        

        mesh.vertices = vertices;
        mesh.uv = UV;
        mesh.triangles = triangles;

        //mesh.SetVertices();
    }
	
	// Update is called once per frame
	void Update () {
        Vector3 v = Camera.main.transform.localPosition;

        v.x = Mathf.Floor(v.x/ unitWidth) * unitWidth;
        v.y = Mathf.Floor(v.y/ unitWidth) * unitWidth;
        v.z = 0;

        float worldSize = unitWidth * size;

        Graphics.DrawMesh(mesh, transform.position + v - new Vector3(worldSize / 2.0f, worldSize / 2.0f,0),
            transform.rotation, mat, 0);
    }
}
