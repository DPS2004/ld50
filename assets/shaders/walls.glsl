vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
  if(Texel(tex, texture_coords).a != 0.0){
    for(float xo=-2.0;xo<=2.0;xo++){
      for(float yo=-2.0;yo<=2.0;yo++){
        if(Texel(tex, vec2(texture_coords.x+xo*(1.0/128.0),texture_coords.y+yo*(1.0/128.0))).a != 1.0){
            return vec4(0.823529412,0.258823529,1,1);
          
        }
      }
    }
    return vec4(0,0,0,1);
  } else {
    return vec4(0,0,0,0);
  }
}