// uniform vec2 u_resolution;
// uniform vec2 u_mouse;
// uniform float u_time;

#iChannel0 "https://picsum.photos/seed/picsum/4096.jpg"

#define cells 25.0
#define cellsize 1.0/cells

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

struct space {
	vec2 dims;
};
space grid = space(vec2(cells));

vec2 get_index(space g, vec2 pos) {
	// [1] — Get current bin
	vec2 currentbin = g.dims * pos;
	// [^] Multiply the number of rows and columns by the normalized (0~1) position

	// [2] — Smudge currentbin
	// vec2 ipart;
	// modf(currentbin, ipart);
	// vec2 center = ipart/cells;
	// [^] Border artifacts

	// vec2 center = ceil(currentbin)/cells;
	// [^] Top row artifact
	// vec2 center = floor(currentbin)/cells;
	// [^] Bottom row and Left column artifact
	// vec2 center = vec2(round(currentbin.x), floor(currentbin.y - cellsize))/cells;
	// vec2 center = fract(currentbin/cells);

	// vec2 center = round(currentbin)/cells; // Border artifacts (minimal)
	// vec2 center = (currentbin * abs(vec2(cos(iTime), sin(iTime))))/cells; // Border artifacts (minimal)
	vec2 center = round(currentbin)/cells; // Border artifacts (minimal)

	return center;
}

void main(){
	float time=iGlobalTime*1.;
	vec2 uv=(gl_FragCoord.xy/iResolution.xy);

	vec2 bin = get_index(grid, uv);

	// vec4 color = texture2D(iChannel0, bin);

	// vec2 s = step(bin*abs(sin(iTime)), uv);
	// vec2 s = step((0.5*(vec2(cos(iTime),sin(iTime)))), uv);
	vec2 s = step(uv, bin) - step(bin, uv) ;
	float sx = s.x * s.y;
	
	// vec4 color = texture2D(iChannel0, sin((bin * sx) + iTime));
	// vec4 color = texture2D(iChannel0, uv + 0.0625*vec2(cos(sx+iTime),sin(sx+iTime)));
	// vec4 color = texture2D(iChannel0, clamp(uv + 0.0625*vec2(cos(sx+iTime),sin(sx+iTime)), 0.0, 1.0));
	// vec4 color = texture2D(iChannel0, abs(uv + 0.003*vec2(cos(sx+iTime),sin(sx+iTime))));
	// vec4 color = texture2D(iChannel0, clamp(uv + sin((bin * sx) + iTime), 0.0, 1.0));
	// gl_FragColor = vec4(vec3(sx),1.0);

	vec2 sm = smoothstep(uv, uv, bin) - smoothstep(bin, bin, uv) ;
	float smx = sm.x * sm.y;
	vec4 color = texture2D(iChannel0, abs(uv + 0.005*vec2(cos(smx+iTime),sin(smx+iTime))));

	gl_FragColor = color;
}