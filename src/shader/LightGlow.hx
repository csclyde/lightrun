package shader;

class LightGlow extends h3d.shader.ScreenShader{
    static var SRC = {
        @param var texture : Sampler2D;
        @param var amount : Float;
        @param var glowColor : Vec4;
        @param var globalPos : Vec4;
        
        function fragment() {
            //pixelColor = texture.get(input.uv);
            var x = (input.position.x/255);
            var y = (input.position.y/255);
            pixelColor.r = 1/x*x;
            pixelColor.g = 1/y*y;
            pixelColor.b = 0;
        }
    }
}

