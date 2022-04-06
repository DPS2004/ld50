uniform vec4 colors[4];

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
  float pixelalpha = Texel(tex, texture_coords).a;
  return vec4(1,1,1,pixelalpha);
}