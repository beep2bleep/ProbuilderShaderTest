using UnityEngine;
using System.Collections;

public class disappearOnClose : MonoBehaviour {

    public Transform _playerTransform;
    public Material _material;
    public float maxDistance = 50f;
    public float minDistance = 10f; 

	// Use this for initialization
	void Start () {
        
    }
	
	// Update is called once per frame
	void Update () {

        if (_playerTransform)
        {
            float dist = Vector3.Distance(_playerTransform.position, transform.position);
            //print("Distance to other: " + dist);
            if(dist > minDistance && dist < maxDistance)
            {
                //Update transparency
                _material.SetFloat("_BlendFactor", (dist - minDistance)/(maxDistance-minDistance));
            }
            else if(dist <= minDistance)
            {
                _material.SetFloat("_BlendFactor", .0F); 
            }
            else if(dist >= maxDistance)
            {
                _material.SetFloat("_BlendFactor", 1.0f); 
            }

        }
    }
}
