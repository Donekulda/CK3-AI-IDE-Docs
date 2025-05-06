Includes = {
	"coat_of_arms/coat_of_arms_textured_emblem.fxh"
}

PixelShader =
{
	MainCode PS_Emblem
	{
		Input = "VS_OUTPUT_COA_ATLAS"
		Output = "PDX_COLOR"
		Code
		[[
			PDX_MAIN
			{
				float4 MaskTex = PdxTex2D( MaskMap, Input.uvPattern );
				float4 EmblemTex = PdxTex2D( EmblemMap, Input.uvEmblem );

				float4 EmblemColor = Emblem( Input, EmblemTex );
				
				#ifndef USE_PORTRAIT_COA
				
					// overlay shading detail
					EmblemColor.rgb = GetOverlay( EmblemColor.rgb, MaskTex.bbb, 0.2 );
					EmblemColor.a *= MaskTex.g * 2;

				#endif

				return EmblemColor;
			}
		]]
	}
}

Effect coa_create_textured_emblem
{
	VertexShader = VertexShaderCOAEmblem
	PixelShader = PS_Emblem
	BlendState = BlendState
}

Effect coa_create_textured_emblem_masked
{
	VertexShader = VertexShaderCOAEmblem
	PixelShader = PS_Emblem
	BlendState = BlendState
	Defines = { "USE_PATTERN_MASK" }
}

Effect coa_create_colored_emblem
{
	VertexShader = VertexShaderCOAEmblem
	PixelShader = PS_Emblem
	BlendState = BlendState
	Defines = { "COLORED_EMBLEM" }
}

Effect coa_create_colored_emblem_pattern_mask
{
	VertexShader = VertexShaderCOAEmblem
	PixelShader = PS_Emblem
	BlendState = BlendState
	Defines = { "USE_PATTERN_MASK" "COLORED_EMBLEM" }
}

Effect coa_create_textured_emblem_portrait
{
	VertexShader = VertexShaderCOAEmblem
	PixelShader = PS_Emblem
	BlendState = BlendState
	Defines = { "USE_PORTRAIT_COA" }
}

Effect coa_create_textured_emblem_masked_portrait
{
	VertexShader = VertexShaderCOAEmblem
	PixelShader = PS_Emblem
	BlendState = BlendState
	Defines = { "USE_PATTERN_MASK" "USE_PORTRAIT_COA" }
}

Effect coa_create_colored_emblem_portrait
{
	VertexShader = VertexShaderCOAEmblem
	PixelShader = PS_Emblem
	BlendState = BlendState
	Defines = { "COLORED_EMBLEM" "USE_PORTRAIT_COA" }
}

Effect coa_create_colored_emblem_pattern_mask_portrait
{
	VertexShader = VertexShaderCOAEmblem
	PixelShader = PS_Emblem
	BlendState = BlendState
	Defines = { "USE_PATTERN_MASK" "COLORED_EMBLEM" "USE_PORTRAIT_COA" }
}
