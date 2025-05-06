Includes = {
	"coat_of_arms/coat_of_arms_pattern.fxh"
}

PixelShader =
{	
	MainCode PS_Pattern
	{
		Input = "VS_OUTPUT_COA_ATLAS"
		Output = "PDX_COLOR"
		Code
		[[
			PDX_MAIN
			{
				float4 MaskTex = PdxTex2D( MaskMap, Input.uvPattern );
				float4 PatternTex = PdxTex2D( PatternMap, Input.uvPattern );
				float4 PatternColor = Pattern( Input, PatternTex );
				
				#ifndef USE_PORTRAIT_COA
					// overlay shading detail
					PatternColor.rgb = GetOverlay( PatternColor.rgb, vec3( MaskTex.b ), 0.2 );
					//PatternColor.a *= MaskTex.g * 2;	
				#endif
				
				return PatternColor;
			}
		]]
	}
}

Effect coa_create_colored_pattern
{
	VertexShader = VertexShaderCOAPattern
	PixelShader = PS_Pattern
}

Effect coa_create_colored_pattern_blend
{
	VertexShader = VertexShaderCOAPattern
	PixelShader = PS_Pattern
	BlendState = BlendStateNoAlpha
}

Effect coa_create_colored_pattern_portrait
{
	VertexShader = VertexShaderCOAPattern
	PixelShader = PS_Pattern
	Defines = { "USE_PORTRAIT_COA" }
}

Effect coa_create_colored_pattern_blend_portrait
{
	VertexShader = VertexShaderCOAPattern
	PixelShader = PS_Pattern
	BlendState = BlendStateNoAlpha
	Defines = { "USE_PORTRAIT_COA" }
}
