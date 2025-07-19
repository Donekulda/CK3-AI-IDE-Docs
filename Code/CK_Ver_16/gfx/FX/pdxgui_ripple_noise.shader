Includes = {
	"cw/pdxgui.fxh"
}

VertexShader =
{
	MainCode VertexShader
	{
		Input = "VS_INPUT_PDX_GUI"
		Output = "VS_OUTPUT_PDX_GUI"
		Code 
		[[
			PDX_MAIN
			{
				return PdxGuiDefaultVertexShader( Input );
			}
		]]
	}	
}

PixelShader =
{
	TextureSampler Texture0
	{
		Ref = PdxTexture0
		MagFilter = "Linear"
		MinFilter = "Linear"
		MipFilter = "Linear"
		SampleModeU = "Wrap"
		SampleModeV = "Wrap"
		MipMapLodBias = -1
	}

	MainCode PixelShader
	{
		Input = "VS_OUTPUT_PDX_GUI"
		Output = "PDX_COLOR"
		Code 
		[[
			PDX_MAIN
			{
				// Add movement to the UV coordinates that the wave texture will use
				const float2 RippleNoiseScaleUV = float2( 2.592f, 1.2f ) * Input.UV0;
				const float2 RippleNoiseSpeedXY = float2( 0.005f, -0.005f );

				float2 RippleNoiseUV = RippleNoiseScaleUV - GuiTime * RippleNoiseSpeedXY;
				float4 Color = PdxTex2D( Texture0, RippleNoiseUV );

				const float2 RippleNoiseScaleUV2 = RippleNoiseScaleUV * 0.5f;
				const float2 RippleNoiseSpeedXY2 = RippleNoiseSpeedXY * 3.5f;

				float2 RippleNoiseUV2 = RippleNoiseScaleUV2 - GuiTime * RippleNoiseSpeedXY2;

				float4 Color2 = PdxTex2D( Texture0, RippleNoiseUV2 );
				Color.a = saturate( Color.a * Color2.a * TextTintColor.a * 0.4f);
				Color = Color * Input.Color;

				return Color;
			}
		]]
	}
}

BlendState BlendState
{
	BlendEnable = yes
	SourceBlend = "SRC_ALPHA"
	DestBlend = "INV_SRC_ALPHA"
}

DepthStencilState DepthStencilState
{
	DepthEnable = no
}

Effect PdxDefaultGUITextIcon
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShader"
}

Effect PdxGuiDefault
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShader"
}

Effect PdxGuiDefaultDisabled
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShader"
	
	Defines = { "DISABLED" }
}
