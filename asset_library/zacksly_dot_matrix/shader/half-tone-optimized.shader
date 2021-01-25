// Shader By Zacksly - https://zacksly.itch.io/
shader_type canvas_item;
uniform bool UseColor;
uniform bool BlackDot;
uniform float AspectRatio;
uniform float Dots;
uniform float _min;
uniform float _max;
uniform bool UseReshade;

void fragment() {

	vec3 uv_grid = fract(vec3(SCREEN_UV, 0.0) * vec3(AspectRatio * Dots, Dots, 0.0));

	float grid = distance(uv_grid, vec3(0.5, 0.5, 0.5));
	
	vec3 raw_cam_image;
	{
		vec4 _tex_read = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
		raw_cam_image = _tex_read.rgb;
	}

	vec3 grayscale;
	{
		vec3 c = raw_cam_image;
		float max1 = max(c.r, c.g);
		float max2 = max(max1, c.b);
		float max3 = max(max1, max2);
		grayscale = vec3(max3, max3, max3);
	}

	vec3 clamped = clamp(grayscale, vec3(_min), vec3(_max));

	vec3 inv_clamped = vec3(1.0, 1.0, 1.0) - clamped;

	bool black_dot_grid = grid > dot(inv_clamped, vec3(0.333333, 0.333333, 0.333333));
	bool white_dot_grid = grid < dot(clamped, vec3(0.333333, 0.333333, 0.333333));

	vec3 grid_result;
	if(BlackDot)
	{
		grid_result = vec3(black_dot_grid ? 1.0 : 0.0);
	}
	else
	{
		grid_result = vec3(white_dot_grid ? 1.0 : 0.0);
	}

	vec3 saturated_image;
	saturated_image = vec3(0.0, 0.0, 0.0);
	{
		vec3 c;
		c = raw_cam_image;
		if ( abs(c.r - c.g) > .1 || abs(c.g - c.b) > .1 || abs(c.b - c.r) > .1 ){
			c.rgb = mix(vec3(0.0), c.rgb, 2); //Brightness
			c.rgb = mix(vec3(0.5), c.rgb, 1); // Contrast
			c.rgb = mix(vec3(dot(vec3(1.0), c.rgb)*0.33333), c.rgb, 2); //Saturation
		} else {
			c= vec3(1.0,1.0,1.0);
		}
		
		saturated_image.rgb = c;
	}

	vec3 screen_image;
	if(UseReshade)
	{
		screen_image = saturated_image;
	}
	else
	{
		screen_image = raw_cam_image;
	}

	vec3 final_image;
	if(UseColor)
	{
		final_image = grid_result * screen_image;
	}
	else
	{
		final_image = grid_result;
	}

	COLOR.rgb = final_image;
}