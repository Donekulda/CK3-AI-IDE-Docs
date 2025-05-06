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
		SampleModeU = "Clamp"
		SampleModeV = "Clamp"
		MipMapLodBias = -1
	}
	TextureSampler ModifyTexture0
	{
		Ref = PdxGuiModifyTexture0
		MagFilter = "Linear"
		MinFilter = "Linear"
		MipFilter = "Linear"
		SampleModeU = "Wrap"
		SampleModeV = "Wrap"
	}

	MainCode PixelShader
	{
		Input = "VS_OUTPUT_PDX_GUI"
		Output = "PDX_COLOR"
		Code 
		[[
			PDX_MAIN
			{
				const float2 WindScaleXY = float2( 0.75f, 1.0f );
				const float2 WindSpeedXY = float2( 0.025f, 0.05f );
				
				// Add movement to the UV coordinates that the wind texture will use
				// The sin(...) will add buoyancy, meaning the height of the texture will go up and down in a wave pattern
				float2 WindUV = WindScaleXY * Input.UV0 - float2( GuiTime * WindSpeedXY.x, sin( GuiTime ) * WindSpeedXY.y );
				
				// Sample the alpha mask / wind texture, R/G/B holds wind while A is a feathered vegetation mask
				// We need to sample it twice because the wind's UV coords are being animated over time, but not the alpha mask
				float AlphaMask = PdxTex2D( ModifyTexture0, Input.UV0 ).a;
				float3 Wind = PdxTex2D( ModifyTexture0, WindUV ).rgb;
				
				// Wind amount, in height/width
				const float2 Amount = float2( 0.0055f, 0.006f );
				
				float2 UV = AlphaMask * Wind.rg * Amount;
				
				float4 Color = PdxTex2D( Texture0, Input.UV0 - UV ) * Input.Color;
				Color.a = Color.a * TextTintColor.a;
				
				// Visualize the wind pattern (debug)
				//Color.rgb = float3(Wind.x, Wind.y, 0.0f);
				
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
