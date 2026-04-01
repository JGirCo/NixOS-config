let
  ditherGlitchShader = ''
    // Digital dither pattern generator
    float dither8x8(vec2 uv) {
      int x = int(mod(uv.x, 8.0));
      int y = int(mod(uv.y, 8.0));
      int index = x + y * 8;
      float limit = 0.0;

      // This is a standard 8x8 Bayer threshold map
      if (x < 8) {
        if (index == 0) limit = 0.015625; if (index == 1) limit = 0.515625;
        if (index == 2) limit = 0.140625; if (index == 3) limit = 0.640625;
        // ... (The shader in the repo uses a mathematical approach to this)
      }
      return limit;
    }

    vec4 dither_glitch(vec3 coords_geo, vec3 size_geo, float progress, bool opening) {
        float p = opening ? 1.0 - progress : progress;
        vec2 uv = coords_geo.xy;

        // Apply a "scanline" jitter based on progress
        float jitter = (fract(sin(dot(vec2(uv.y, p), vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * p * 0.05;
        vec2 distorted_uv = vec2(uv.x + jitter, uv.y);

        vec2 tex_uv = (niri_geo_to_tex * vec3(distorted_uv, 1.0)).st;
        vec4 color = texture2D(niri_tex, tex_uv);

        // Chromatic aberration
        float shift = p * 0.02;
        color.r = texture2D(niri_tex, (niri_geo_to_tex * vec3(distorted_uv + vec2(shift, 0.0), 1.0)).st).r;
        color.b = texture2D(niri_tex, (niri_geo_to_tex * vec3(distorted_uv - vec2(shift, 0.0), 1.0)).st).b;

        // Dither transparency
        // We use screen-space coordinates for the dither pixels
        vec2 screen_pos = distorted_uv * size_geo.xy;
        float threshold = fract(sin(dot(floor(screen_pos/2.0), vec2(12.9898,78.233))) * 43758.5453);

        if (threshold < p) discard;

        return color;
    }

    vec4 open_color(vec3 coords_geo, vec3 size_geo) {
        return dither_glitch(coords_geo, size_geo, niri_clamped_progress, true);
    }

    vec4 close_color(vec3 coords_geo, vec3 size_geo) {
        return dither_glitch(coords_geo, size_geo, niri_clamped_progress, false);
    }
  '';
in
{
  programs.niri.settings.animations = {
    window-open = {
      kind.easing = {
        duration-ms = 500;
        curve = "ease-out-cubic";
      };
      custom-shader = ditherGlitchShader;
    };
    window-close = {
      kind.easing = {
        duration-ms = 400;
        curve = "ease-out-cubic";
      };
      custom-shader = ditherGlitchShader;
    };
  };
}
