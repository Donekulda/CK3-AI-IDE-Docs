Includes = {
	"cw/pdxgui.fxh"
	"standardfuncsgfx.fxh"
	"cw/random.fxh"
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

				return vec4(1.0);
			}
		]]
	}

	MainCode RippleNoiseShader
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

	MainCode GodRayShader
	{
		Input = "VS_OUTPUT_PDX_GUI"
		Output = "PDX_COLOR"
		Code
		[[
			struct RaySettings
			{
				float2 _UV0;
				float _FadeTop;
				float _FadeBottom;
				bool _TopFadoutWave;
				float _WaveFerquence;
				float _RaySpeed;
				float _RayDensity1;
				float _RayDensity2;
				float _RayIntensity;
			};

			float CalcLegendRay( in RaySettings RayData )
			{
				float StrengthScale = 1.2f;
				float Speed = GlobalTime * 0.1f * RayData._RaySpeed;
				float SpeedScale = RayData._RayDensity1 * 0.2f;
				float2 Ray1 = float2( RayData._UV0.x * RayData._RayDensity1 + sin( Speed ) * SpeedScale, 1.0f );
				float2 Ray2 = float2( RayData._UV0.x * RayData._RayDensity2 + sin( Speed * 2 ) * SpeedScale, 1.0f );
				
				float Rays;
				float BorderTextureNoise1 = PdxTex2D( Texture0, Ray1 ).g;
				float BorderTextureNoise2 = PdxTex2D( Texture0, Ray2 ).b;
				Rays = clamp( BorderTextureNoise1 + ( BorderTextureNoise2 * RayData._RayIntensity ), 0.0f, 1.0f );
				Rays *= smoothstep( 0.0f, RayData._FadeTop, RayData._UV0.y );

				// Fade out bottom
				Rays *= smoothstep( 0.0001f , RayData._FadeBottom , (  1.0f - RayData._UV0.y ) );
				return Rays * StrengthScale;
			}

			PDX_MAIN
			{
				float GodRays = 0.0f;
				float2 UV = Input.UV0;
				const float Angle = 0.00f;
				const float2 Position = float2( -1.2f, 0.2f );
				const float Spread  = 0.5f;
				UV += Position;
				UV /= ( ( UV.y + Spread ) + ( UV.y * Spread ) );
				RaySettings GodRaySettings;
				GodRaySettings._UV0 = UV;
				GodRaySettings._FadeTop = 0.0f;
				GodRaySettings._FadeBottom = 1.2f;
				GodRaySettings._TopFadoutWave = false;
				GodRaySettings._RaySpeed = 2.0f;
				GodRaySettings._RayDensity1 = 0.720f;
				GodRaySettings._RayDensity2 = 5.15f;
				GodRaySettings._RayIntensity = 0.1f;
				GodRays = CalcLegendRay( GodRaySettings );
				
				static float3 GodRaysColor = float3( 0.98f, 0.95f, 0.87f );

				float3 Diffuse = ( GodRays * GodRaysColor );
				float4 Color = float4( Diffuse, GodRays );
				return Color;
			}
		]]
	}

	MainCode FogShader
	{
		Input = "VS_OUTPUT_PDX_GUI"
		Output = "PDX_COLOR"
		Code 
		[[
			PDX_MAIN
			{
				const float2 RippleNoiseScaleUV =  Input.UV0 * 0.5f;
				const float2 RippleNoiseSpeedXY = float2( 0.021f, -0.005f );
				float2 RippleNoiseUV = RippleNoiseScaleUV - GuiTime * RippleNoiseSpeedXY;
				float4 Color = PdxTex2D( Texture0, RippleNoiseUV );

				const float2 RippleNoiseScaleUV2 = RippleNoiseScaleUV * 1.5f;
				const float2 RippleNoiseSpeedXY2 = RippleNoiseSpeedXY * 0.5f;
				float2 RippleNoiseUV2 = RippleNoiseScaleUV2 - GuiTime * RippleNoiseSpeedXY2;
				float4 Color2 = PdxTex2D( Texture0, RippleNoiseUV2 );

				const float2 RippleNoiseScaleUV3 = RippleNoiseScaleUV2 * 0.5f;
				const float2 RippleNoiseSpeedXY3 = RippleNoiseSpeedXY2 * 2.0f;
				float2 RippleNoiseUV3 = RippleNoiseScaleUV3 - GuiTime * RippleNoiseSpeedXY3;
				float4 Color3 = PdxTex2D( Texture0, RippleNoiseUV3 );

				float Noise = Color.b * Color2.b * Color3.b ;
				Noise = lerp( 0.2f, 0.9f, Noise);
				Color = float4( vec3( Noise ), Noise * 1.5f );
				return Color;
			}
		]]
	}

	MainCode HeavySmokeShader
	{
		Input = "VS_OUTPUT_PDX_GUI"
		Output = "PDX_COLOR"
		Code 
		[[
			PDX_MAIN
			{
				const float2 NoiseScaleUV =  Input.UV0;
				const float2 NoiseSpeedXY = float2( 0.21f, -0.16f );
				float2 NoiseUV = NoiseScaleUV - GuiTime * NoiseSpeedXY;
				float4 Noise1 = PdxTex2D( Texture0, NoiseUV );

				const float2 NoiseScaleUV2 = NoiseScaleUV * 0.8f;
				const float2 NoiseSpeedXY2 = NoiseSpeedXY * 0.5f;
				float2 NoiseUV2 = NoiseScaleUV2 - GuiTime * NoiseSpeedXY2;
				float4 Noise2 = PdxTex2D( Texture0, NoiseUV2 );

				const float2 NoiseScaleUV3 = NoiseScaleUV2 * 0.5f;
				const float2 NoiseSpeedXY3 = NoiseSpeedXY * 1.5f;
				float2 NoiseUV3 = NoiseScaleUV3 - GuiTime * NoiseSpeedXY3;
				float4 Noise3 = PdxTex2D( Texture0, NoiseUV3 );

				float Noise = Noise1.b * Noise2.b * Noise3.b;
				Noise = lerp( 0.5f, 1.0f, Noise);

				Noise = min( lerp( 0.8f * Noise, Noise, Input.UV0.y ), 1.0f );

				float4 Color = float4( vec3( Noise * 0.5f ), Noise );
				float4 Color2 = float4( 0.5569f,  0.5059f, 0.3020f, Noise );

				Color = lerp( Color, Color2, Input.UV0.y);

				return Color;
			}
		]]
	}

	MainCode SnowShader
	{
		Input = "VS_OUTPUT_PDX_GUI"
		Output = "PDX_COLOR"
		Code 
		[[
			PDX_MAIN
			{
				const float SnowStartLayer = 1.0f;
				const float SnowNumMainLayers = 6.0f;
				const float SnowNumSecondLayers = 2.0f;
				const float SnowTiling = 3.5f;
				const float SnowSkipFactor = 2.0f;
				const float SnowOpacity = 0.7f;
				const float4 SnowControl = Input.Color * 10.0f;
				const float SnowFallSpeed =  SnowControl.r;
				const float SnowWaveSpeed =  SnowControl.g;
				const float SnowWindStrength = SnowControl.b;
				const float SnowFogStrength = SnowControl.a;

				float2 UV = Input.UV0;
				float4 SnowColor = float4( vec3( 1.0f ), 0 );
				float2 InputUV = float2( UV.x + GuiTime * SnowWindStrength , UV.y );
				InputUV = frac( InputUV );

				float FallSpeed = GuiTime * SnowFallSpeed;
				for( float i = SnowStartLayer + 1; i <= SnowNumMainLayers; i++ )
				{
					float LayerOffset = CalcRandom( i * 721 );
					float2 DefultLayerUV = InputUV * i * SnowTiling;
					for( float j = 0; j < SnowNumSecondLayers; j++ )
					{
						float2 SnowUV = DefultLayerUV;
						float2 Offset = float2( LayerOffset, CalcRandom( j * 156 ) );
						SnowUV += Offset.yx;
						
						float2 GridID = floor( SnowUV );
						float gridRandom = CalcRandom( GridID.x * i * j + 1 );
						float fallOffset = sin( FallSpeed * gridRandom + GridID.x * GridID.x ) + ( GuiTime * ( SnowFallSpeed + SnowFallSpeed * CalcRandom( GridID.x + 1 ) + 0.1f ) );
						SnowUV.y -= fallOffset;

						GridID = floor( SnowUV );
						
						if ( ( GridID.x + GridID.y ) % SnowSkipFactor != 0 )
						{
							continue;
						}

						float RandomNoise = ( CalcRandom( ( GridID.x + 1 ) * ( GridID.y + 1 ) * ( i + 1 + j ) ) + 0.001f ) * GuiTime;
						SnowUV.y += sin( sin( RandomNoise ) + RandomNoise * SnowWaveSpeed ) * 0.2f - 0.5f;
						SnowUV.x += sin( RandomNoise + sin( RandomNoise + GridID.x * GridID.y + GuiTime * SnowWaveSpeed ) * 0.5f ) * 0.25f;
						SnowUV = frac( SnowUV );

						SnowUV.y *= 0.5f;
						float WeatherColor = PdxTex2DLod0( Texture0, SnowUV ).b;
						SnowColor.a = max( SnowColor.a, WeatherColor );
					}
				}
				SnowColor.a *= SnowOpacity;

				//Fog
				float2 FogUV = float2 ( UV.x  + GuiTime * 0.1f , UV.y * 0.5f - FallSpeed * 0.05f );
				float FogMask = PdxTex2DLod0( Texture0, FogUV ).a;
				float Fog = smoothstep( 0.0f, 2.f, 1 - UV.y ) * FogMask * SnowFogStrength;
				SnowColor.a += Fog;
				return SnowColor;
			}
		]]
	}

	MainCode SandStormShader
	{
		Input = "VS_OUTPUT_PDX_GUI"
		Output = "PDX_COLOR"
		Code 
		[[
			PDX_MAIN
			{
				const float2 NoiseScaleUV =  Input.UV0;
				const float2 NoiseSpeedXY = float2( -0.81f, -0.10f );
				float2 NoiseUV = NoiseScaleUV - GuiTime * NoiseSpeedXY;
				float4 Noise1 = PdxTex2D( Texture0, NoiseUV );

				const float2 NoiseScaleUV2 = NoiseScaleUV * 1.5f;
				const float2 NoiseSpeedXY2 = NoiseSpeedXY * 0.5f;
				float2 NoiseUV2 = NoiseScaleUV2 - GuiTime * NoiseSpeedXY2;
				float4 Noise2 = PdxTex2D( Texture0, NoiseUV2 );

				const float2 NoiseScaleUV3 = NoiseScaleUV * 1.5f;
				const float2 NoiseSpeedXY3 = NoiseSpeedXY * 1.5f;
				float2 NoiseUV3 = NoiseScaleUV3 - GuiTime * NoiseSpeedXY3;
				float4 Noise3 = PdxTex2D( Texture0, NoiseUV3 );

				float Noise = Noise1.r * Noise2.g * Noise3.b;
				Noise = lerp( 0.4f, 0.9f, Noise);

				Noise = min( lerp( 0.3f * Noise, 1.4f * Noise, Input.UV0.y ), 1.0f );

				float4 Color = float4( 0.698f, 0.6f, 0.431f, Noise);
				return Color;
			}
		]]
	}

	MainCode EarthquakeShader
	{
		Input = "VS_OUTPUT_PDX_GUI"
		Output = "PDX_COLOR"
		Code 
		[[
			PDX_MAIN
			{
				const float2 NoiseScaleUV =  Input.UV0;
				const float2 NoiseSpeedXY = float2( -0.01f, -0.05f );
				float2 NoiseUV = NoiseScaleUV - GuiTime * NoiseSpeedXY;
				float4 Noise1 = PdxTex2D( Texture0, NoiseUV );

				const float2 NoiseScaleUV2 = NoiseScaleUV * 2.5f;
				const float2 NoiseSpeedXY2 = NoiseSpeedXY * 1.5f;
				float2 NoiseUV2 = NoiseScaleUV2 - GuiTime * NoiseSpeedXY2;
				float4 Noise2 = PdxTex2D( Texture0, NoiseUV2 );

				const float2 NoiseScaleUV3 = NoiseScaleUV * 1.5f;
				const float2 NoiseSpeedXY3 = NoiseSpeedXY * 2.5f;
				float2 NoiseUV3 = NoiseScaleUV3 - GuiTime * NoiseSpeedXY3;
				float4 Noise3 = PdxTex2D( Texture0, NoiseUV3 );

				float Noise = Noise1.r * Noise2.g * Noise3.b;
				Noise = lerp( 0.2f, 0.3f, Noise);

				Noise = min( lerp( 0.2f * Noise, 1.4f * Noise, Input.UV0.y ), 1.0f );

				float4 Color = float4( 0.698f, 0.6f, 0.431f, Noise);
				return Color;
			}
		]]
	}

	MainCode RainShader
	{
		Input = "VS_OUTPUT_PDX_GUI"
		Output = "PDX_COLOR"
		Code
		[[
			struct RainSettings
			{
				float _FogUVScale;
				float2 _FogSpeed;
				float _FogStrengthMin;
				float _FogStrengthMax;
				float _RainStartLayer;
				float _RainEndLayers;
				float _RainFallSpeed;
				float _RainOpacity;
				float _RainNoiseStrength;
			};
			
			float2x2 Rotate( float Angle ){
				return float2x2( float2( cos( Angle ), -sin( Angle ) ), float2( sin( Angle ), cos( Angle ) ) );
			}

			RainSettings GetRainSettings()
			{
				RainSettings Settings;
				#ifdef RAINY_FOG
					Settings._FogUVScale = 1.0f;
					Settings._FogSpeed = float2( -0.05f, -0.0f );
					Settings._FogStrengthMin = 0.25f;
					Settings._FogStrengthMax = 0.9f;
					Settings._RainStartLayer = 10.0f;
					Settings._RainEndLayers = 13.0f;
					Settings._RainFallSpeed = 0.45f;
					Settings._RainOpacity = 0.1f;
					Settings._RainNoiseStrength = 0.06f;
				#endif

				#ifdef LIGHTNING_STORM
					Settings._FogUVScale = 0.5f;
					Settings._FogSpeed = float2( 0.6f, 0.05f );
					Settings._FogStrengthMin = 0.3f;
					Settings._FogStrengthMax = 0.6f;
					Settings._RainStartLayer = 2.0f;
					Settings._RainEndLayers = 5.0f;
					Settings._RainFallSpeed = 0.6f;
					Settings._RainOpacity = 0.1f;
					Settings._RainNoiseStrength = 0.12f;
				#endif

				return Settings;
			}

			void ApplyFog( in float2 UV, RainSettings Settings, inout float4 Color )
			{
				const float2 NoiseScaleUV = UV * Settings._FogUVScale;
				const float2 NoiseSpeedXY = Settings._FogSpeed;
				float2 NoiseUV = NoiseScaleUV - GuiTime * NoiseSpeedXY;
				float4 Noise1 = PdxTex2D( Texture0, NoiseUV );

				const float2 NoiseScaleUV2 = NoiseScaleUV * 2.5f;
				const float2 NoiseSpeedXY2 = NoiseSpeedXY * 1.5f;
				float2 NoiseUV2 = NoiseScaleUV2 - GuiTime * NoiseSpeedXY2;
				float4 Noise2 = PdxTex2D( Texture0, NoiseUV2 );

				const float2 NoiseScaleUV3 = NoiseScaleUV * 0.5f;
				const float2 NoiseSpeedXY3 = NoiseSpeedXY * 2.5f;
				float2 NoiseUV3 = NoiseScaleUV3 - GuiTime * NoiseSpeedXY3;
				float4 Noise3 = PdxTex2D( Texture0, NoiseUV3 );

				float Noise = Noise1.a * Noise2.a * Noise3.a;
				Noise = lerp( Settings._FogStrengthMin, Settings._FogStrengthMax, Noise);
				Color = float4( vec3( Noise ), Noise * 1.5f );
			}

			void ApplyRain( in float2 UV, in RainSettings Settings, inout float4 Color )
			{
				const float Time = GuiTime % 1000;
				float RainColor = 0.0f;
				float NoiseColor = 0.0f;
				float RainFallOffset = Time * Settings._RainFallSpeed;
				for( float i = Settings._RainStartLayer; i < Settings._RainEndLayers; i++ )
				{
					float2 Scale = float2( 2.0f, 0.08f ) * i;
					float2 UVOffset = float2( sin( Time + sin( Time + i ) ) * 0.1f, ( i * 0.335f ) - RainFallOffset );
					#ifdef LIGHTNING_STORM
						float2 RotateUV = mul( Rotate( lerp( 0.2f, 0.3f, abs( sin( GuiTime* i + sin( GuiTime  ) ) ) ) ), UV );
						float2 NoiseUV = RotateUV * Scale + UVOffset;
					#else
						float2 NoiseUV = UV * Scale + UVOffset;
					#endif
					
					float2 GridID = floor( NoiseUV );
					NoiseUV.y += CalcRandom( GridID.x );
					NoiseUV = frac( NoiseUV );
					float4 TextureColor = PdxTex2DLod0( Texture0, NoiseUV );
					float TempColor = TextureColor.r * TextureColor.g * 1.5f;

					NoiseColor = max( NoiseColor, TempColor );
				}

				RainColor += NoiseColor * Settings._RainNoiseStrength ;
				RainColor += clamp( pow( abs( NoiseColor ), 50.0f ) * 10.0f, 0.0f, ( 1.0f - UV.y ) * 0.2f ) * Settings._RainOpacity;

				float Mask = smoothstep( 0.02f, 1.0f, 1.0f - UV.y / 2.0f );
				RainColor *= Mask;
				Color.rgba += RainColor;
			}

			void ApplyLighting( inout float4 Color)
			{
				float Time = GuiTime % 1000;
				float Lighting = sin( Time * sin( Time * 10.f ) );
				Lighting *= pow( max( 0.f, sin( Time + sin( Time ) ) ), 10.f ) * 0.25f;
				Color.rgba = min( Color.a * ( 1.f + Lighting ), 0.9f);
			}

			PDX_MAIN
			{
				RainSettings Settings = GetRainSettings();
				float4 Color = vec4( 0.0f );
				ApplyFog( Input.UV0, Settings, Color );
				ApplyRain( Input.UV0, Settings, Color );

				#ifdef LIGHTNING_STORM
					#ifdef NO_LIGHTING
						Color.rgba = Color.aaaa;
					#else
						ApplyLighting( Color );
					#endif
				#endif

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

Effect RippleNoise
{
	VertexShader = "VertexShader"
	PixelShader = "RippleNoiseShader"
}

Effect RippleNoiseDisabled
{
	VertexShader = "VertexShader"
	PixelShader = "RippleNoiseShader"
	Defines = { "DISABLED" }
}

Effect GodRay
{
	VertexShader = "VertexShader"
	PixelShader = "GodRayShader"
}

Effect GodRayDisabled
{
	VertexShader = "VertexShader"
	PixelShader = "GodRayShader"
	Defines = { "DISABLED" }
}

Effect Fog
{
	VertexShader = "VertexShader"
	PixelShader = "FogShader"
}

Effect FogDisabled
{
	VertexShader = "VertexShader"
	PixelShader = "FogShader"
	Defines = { "DISABLED" }
}

Effect HeavySmoke
{
	VertexShader = "VertexShader"
	PixelShader = "HeavySmokeShader"
}

Effect HeavySmokeDisabled
{
	VertexShader = "VertexShader"
	PixelShader = "HeavySmokeShader"
	Defines = { "DISABLED" }
}

Effect Snow
{
	VertexShader = "VertexShader"
	PixelShader = "SnowShader"
}

Effect SnowDisabled
{
	VertexShader = "VertexShader"
	PixelShader = "SnowShader"
	Defines = { "DISABLED" }
}

Effect Sandstorm
{
	VertexShader = "VertexShader"
	PixelShader = "SandstormShader"
}

Effect SandstormDisabled
{
	VertexShader = "VertexShader"
	PixelShader = "SandstormShader"
	Defines = { "DISABLED" }
}

Effect Earthquake
{
	VertexShader = "VertexShader"
	PixelShader = "EarthquakeShader"
}

Effect EarthquakeDisabled
{
	VertexShader = "VertexShader"
	PixelShader = "EarthquakeShader"
	Defines = { "DISABLED" }
}

Effect RainyFog
{
	VertexShader = "VertexShader"
	PixelShader = "RainShader"
	Defines = { "RAINY_FOG" }
}

Effect RainyFogDisabled
{
	VertexShader = "VertexShader"
	PixelShader = "RainShader"
	Defines = { "RAINY_FOG" "DISABLED" }
}

Effect LightningStorm
{
	VertexShader = "VertexShader"
	PixelShader = "RainShader"
	Defines = { "LIGHTNING_STORM" }
}

Effect LightningStormDisabled
{
	VertexShader = "VertexShader"
	PixelShader = "RainShader"
	Defines = { "LIGHTNING_STORM" "DISABLED" }
}

Effect RainStorm
{
	VertexShader = "VertexShader"
	PixelShader = "RainShader"
	Defines = { "LIGHTNING_STORM" "NO_LIGHTING" }
}

Effect RainStormDisabled
{
	VertexShader = "VertexShader"
	PixelShader = "RainShader"
	Defines = { "LIGHTNING_STORM" "NO_LIGHTING" "DISABLED" }
}