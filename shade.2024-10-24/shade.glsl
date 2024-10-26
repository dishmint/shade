// uniform vec2 u_resolution;
// uniform vec2 u_mouse;
// uniform float u_time;

#iChannel0 "https://picsum.photos/seed/picsum/4096.jpg"

#define texSize 4096.0
#define cells 10.0
#define cellwidth texSize/cells

#define D3 0.33
#define D4 0.25

#define TAU 6.283185307179586
#define QTAU TAU*.25
#define HTAU TAU*.5

float vec4sum(vec4 v){
	return v.r + v.g + v.b + v.a;
}

float vec4mean(vec4 v){
	return vec4sum(v) * D4;
}

float vec3sum(vec3 v){
	return v.r + v.g + v.b;
}

float vec3mean(vec3 v){
	return vec3sum(v) * D3;
}

vec2 orbit(vec2 p, float r, float a){
	return p + (r * vec2(cos(a), sin(a)));
}

void main(){
	float time=iGlobalTime*1.;
	vec2 uv=(gl_FragCoord.xy/iResolution.xy);

	vec4 color = vec4(vec3(0.0), 1.0);

	vec2 split = fract(uv * 10.0);

	bool xmark = (split.x > 0.49 && split.x < 0.51);
	bool ymark = (split.y > 0.49 && split.y < 0.51);

	if(!xmark && !ymark) {
		color = texture2D(iChannel0, uv);
	}

	// [1] — position of center of kernel
	// [2] — set current pixel color to center pixel color
	
	gl_FragColor = color;
	// vec4 tex0 = texture2D(iChannel0,uv);
	// vec4 tex0 = texture2D(iChannel0,fract(uv * 2.0));

	// float angle = vec4mean(tex0) * TAU;

	// vec2 xy = orbit(uv, 1.0, angle);
	// vec2 xy = orbit(uv, 1.0, angle+(iTime * 0.1));
	
	// gl_FragColor = texture2D(iChannel0, xy);
	// gl_FragColor = texture2D(iChannel0, uv-xy);
	// gl_FragColor = texture2D(iChannel0, uv+xy);
	// gl_FragColor = texture2D(iChannel0, uv*xy);
	// gl_FragColor = texture2D(iChannel0, uv/xy);
	
	// vec4 tex1 = texture2D(iChannel0, uv-xy);
	// float mu = vec4mean(tex1);
	// gl_FragColor = tex0-vec4(mu);
}