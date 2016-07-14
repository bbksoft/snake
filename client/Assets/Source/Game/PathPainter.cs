using UnityEngine;
using System.Collections;

public class PathPainter : MonoBehaviour {

    MeshFilter m;

    void Awake()
    {
        m = GetComponent<MeshFilter>();
    }


    public void UpdatePath(Vector2 firstForward,Vector2[] path,float width)
    {
        Mesh mesh = new Mesh();

        int count = path.Length;

        Vector3[] vertices = new Vector3[count * 4];
        Vector2[] UV = new Vector2[count * 4];
        Color[] colors = new Color[count * 4];

        int[] triangles = new int[count * 6];

        Vector3 forward = firstForward;
        forward = new Quaternion(0, 0, 0.7071f, 0.7071f) * forward;


        Vector3 pos0 = forward * width;
        Vector3 pos1 = -forward *  width;

        for (int pos = count-2; pos >= 0; pos--)
        {
            forward = path[pos+1] - path[pos];
            forward = forward.normalized;
            forward = new Quaternion(0, 0, 0.7071f, 0.7071f) * forward;

            Vector3 curPos = path[pos];
            curPos = curPos - transform.localPosition;
            curPos.z = 0;
            Vector3 pos2 = curPos - forward * width;
            Vector3 pos3 = curPos + forward * width;

            vertices[pos * 4 + 0] = pos0;
            vertices[pos * 4 + 1] = pos1;
            vertices[pos * 4 + 2] = pos2;
            vertices[pos * 4 + 3] = pos3;

            pos0 = pos3;
            pos1 = pos2;


            UV[pos * 4 + 0] = new Vector2(1, 1);
            UV[pos * 4 + 1] = new Vector2(1, 0);
            UV[pos * 4 + 2] = new Vector2(0, 0);
            UV[pos * 4 + 3] = new Vector2(0, 1);

            triangles[pos * 6 + 0] = pos * 4 + 0;
            triangles[pos * 6 + 1] = pos * 4 + 1;
            triangles[pos * 6 + 2] = pos * 4 + 3;
            triangles[pos * 6 + 3] = pos * 4 + 3;
            triangles[pos * 6 + 4] = pos * 4 + 1;
            triangles[pos * 6 + 5] = pos * 4 + 2;
        }

        mesh.vertices = vertices;
        mesh.uv = UV;
        mesh.triangles = triangles;

        m.mesh = mesh;
    }
}
