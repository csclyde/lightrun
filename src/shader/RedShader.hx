package shader;

class RedShader extends  h3d.shader.ScreenShader{
    static var SRC = {
        @param var texture : Sampler2D;
        @param var red : Float;
        
        function fragment() {
            pixelColor = texture.get(input.uv);
            pixelColor.r = red; // change red channel
        }
    }
}