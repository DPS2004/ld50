vec4 effect(vec4 color, Image texture, vec2 uv, vec2 fc) {
    vec4 source = color * Texel(texture, uv);
    if (source.a > 0.0) {
        return source;
    }
	float a = 0.0;
    vec2 step = vec2(1.0 / love_ScreenSize.x, 1.0 / love_ScreenSize.y);
    a += Texel(texture, uv + vec2(step.x, 0)).a;
    a += Texel(texture, uv + vec2(-step.x, 0)).a;
    a += Texel(texture, uv + vec2(0, step.y)).a;
    a += Texel(texture, uv + vec2(0, -step.y)).a;
	return vec4(1, 1, 1, a);
}