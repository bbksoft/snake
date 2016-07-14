using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;

public class GameAPI {

	static public void LoadScene(int id)
    {
        SceneManager.LoadSceneAsync(id, LoadSceneMode.Single);
        //SceneManager.LoadScene(id, LoadSceneMode.Single);
    }

    static public void UnloadScene(int id)
    {
        SceneManager.UnloadScene(id);
    }


    static public void SetText(GameObject obj, string text)
    {
        if (obj == null) return;

        obj.transform.forward = Camera.main.transform.forward;

        TextMesh t = obj.GetComponent<TextMesh>();
        if (t)
        {
            t.text = text;
        }
    }

    static public float GetAnimTime(Animation a, string name)
    {
		var st = a.GetClip(name);

		if ( st == null)
		{
			return 0.1f;
		}
		else
		{
        	return a.GetClip(name).length;
		}
    }

    static public void RealParitcle(GameObject obj)
    {
        if (obj == null) return;

        obj.AddComponent<RealPlay>();
    }

    static public void RealParitcleQuit(GameObject obj)
    {
        if (obj == null) return;

        RealPlay r = obj.GetComponent<RealPlay>();
        if (r)
        {
            Object.Destroy(r);
        }
    }

    static public void StopParticleLoop(GameObject obj)
    {
        if (obj == null) return;

        ParticleSystem[] particle = obj.GetComponentsInChildren<ParticleSystem>();
        for (int i = 0; i < particle.Length; i++)
        {
            particle[i].loop = false;
            particle[i].Play();
        }
    }

    static public void RealAnim(GameObject obj,string anim)
    {
        if (obj == null) return;

        RealPlay r = obj.GetComponent<RealPlay>();
        if (r==null)
        {
            r = obj.AddComponent<RealPlay>();
        }
        r.SetAnim(anim);
    }

    static public void RealAnimQuit(GameObject obj)
    {
        if (obj == null) return;

        RealPlay r = obj.GetComponent<RealPlay>();
        if (r)
        {
            Object.Destroy(r);
        }
    }

    static public void AddPosInParent(GameObject obj, GameObject parent, string pos)
    {
        if (obj == null)
        {
            return;
        }

        Transform child = parent.transform.FindChild(pos);

        obj.transform.parent = child;
        obj.transform.localPosition = Vector3.zero;
        obj.transform.localScale = Vector3.one;
    }

    static public void AddPosInParent(GameObject obj, GameObject parent, float pos)
    {
        if ( obj == null)
        {
            return;
        }

        Transform t = parent.transform;

        obj.transform.parent = t;

        BoxCollider box = t.GetComponent<BoxCollider>();
		float y = 1.8f;
		if ( box != null )
		{
			y = box.size.y;
		}
        obj.transform.localPosition = new Vector3(0, y*pos, 0);
        obj.transform.localScale = Vector3.one;
    }


    static public Vector3 GetPosIn(GameObject parent, string pos)
    {
        Transform child = parent.transform.FindChild(pos);

        return child.position;
    }

    static public Vector3 GetPosIn(GameObject parent, float pos)
    {

        Transform t = parent.transform;
        BoxCollider box = t.GetComponent<BoxCollider>();
		float y = 1.8f;
		if (box != null)
		{
			y = box.size.y;
		}
        return new Vector3(t.position.x, y * pos, t.position.z);
    }


    static public bool IsAnimEnd(Animation a, string name)
    {
		if ( a[name] == null)
		{
			Debug.Log("can't found anim " + name);
			return true;
		}

        if (a[name].wrapMode == WrapMode.ClampForever)
        {

            if (a[name].time >= a[name].length)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return (!a.IsPlaying(name));
        }
    }

    static public void PlayAnim(Animation a,string name, float speed)
    {
        a[name].speed = speed;
        a.Play(name);
    }
    static public void CrossFade(Animation a, string name, float speed)
    {
		if ( a[name] != null)
		{
        	a[name].speed = speed;
        	a.CrossFade(name);
		}
		else
		{
			Debug.Log("can't found anim " + name);
		}
    }
    static public void PauseAnim(GameObject obj, bool value)
    {

        RealPlay r = obj.GetComponent<RealPlay>();
        if (r != null)
        {
            r.Pause(value);
        }
    }

    const float dx_nav = 1.5f;
    const float dx_nav_max = dx_nav + 0.1f;

    static public Vector3 NavPath(Vector3 src, Vector3 des,float size)
    {
        NavMeshPath path = new NavMeshPath();
        if ( NavMesh.CalculatePath(src,
            des, -1,path) )
        {
            //Debug.Log(path.corners[1]);
            return path.corners[1];
        }

        Vector3 forward = src - des;
        forward = forward.normalized;

        for (int i=0; i<360; i+=30)
        {
            Quaternion q = Quaternion.AngleAxis(30, Vector3.up);
            Vector3 pos = q * forward * size * dx_nav_max;
            pos += des;

            if (NavMesh.CalculatePath(src,
                pos, -1, path))
            {
                //Debug.Log(path.corners[1]);
                return path.corners[1];
            }
        }

        return des;
    }

    static public void AddNavColl(GameObject obj, float size)
    {
        NavMeshObstacle n = obj.AddComponent<NavMeshObstacle>();
        n.carving = true;
        n.carvingMoveThreshold = 0.2f;
        //n.carveOnlyStationary = false;
        n.carvingMoveThreshold = 0.1f;
        n.carvingTimeToStationary = 0.1f;
        size = size * dx_nav;
        n.size = new Vector3(size, size, size);
    }

    static public void SetAlpha(GameObject obj, float a)
    {
        Renderer[] rs = obj.GetComponentsInChildren<Renderer>();

        for (int i = 0; i < rs.Length; i++)
        {
            //if (rs[i].material.HasProperty("color"))
            //{
            var c = rs[i].material.color;
            rs[i].material.color = new Color(c.r, c.g, c.b, a);
            //}
        }
    }

    static public void AddOffAnim(GameObject obj, Vector3 off, float time)
    {
        SAnim s = obj.AddComponent<SAnim>();
        s.param = off;
        s.len = time;
    }

    static public void LinkEffectAnim(GameObject obj, GameObject src, GameObject des, float node)
    {
        LinkEffectAnim(obj, src, des, node, -1);
    }
    static public void LinkEffectAnim(GameObject obj, GameObject src, GameObject des, float node, float time)
    {
        LinkEffect e = obj.AddComponent<LinkEffect>();
        e.src = src;
        e.des = des;
        e.offPos = node;
        e.SetLife(time);
    }

    static public void LinkEffect(GameObject obj, GameObject src, GameObject des, float node)
    {
        LinkEffect(obj, src, des, node, -1);
    }
    static public void LinkEffect(GameObject obj, GameObject src, GameObject des, float node, float time)
    {
        LinkEffect e = obj.AddComponent<LinkEffect>();
        e.src = src;
        e.des = des;
        e.offPos = node;

        if ( time > 0 )
        {
            Delay d = obj.AddComponent<Delay>();
            d.delay = time;
            d.fun = MyFuns.TFun.DelSelf;
        }
    }


	// for snake AddPosInParent
	static public void DrawPath(GameObject obj, Vector2 forward, Vector2[] path,float width)
	{
	  PathPainter p = obj.GetComponent<PathPainter>();
	  if (p == null)
	  {
		  p = obj.AddComponent<PathPainter>();
	  }
	  p.UpdatePath(forward,path,width);
	}

	static public void SetCameraFllow2D(GameObject obj)
	{
		Fllow2D f = Camera.main.gameObject.GetComponent<Fllow2D>();

		if (f == null)
		{
			f = Camera.main.gameObject.AddComponent<Fllow2D>();
		}

        f.obj = obj;
	}



}
