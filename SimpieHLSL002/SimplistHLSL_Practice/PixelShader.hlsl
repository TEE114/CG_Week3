Texture2D tex : register(t0);
SamplerState samp : register(s0);

// 只用一个常量缓冲区 b0
cbuffer MVP : register(b0)
{
    float4x4 model;
    float4x4 view;
    float4x4 proj;
    float4x4 texRot;

    // 光照参数直接放这里
    float3 lightPos;
    float3 lightColor;
    float3 viewPos;
    float shininess;
};

struct PSInput
{
    float4 pos : SV_POSITION;
    float4 color : COLOR;
    float2 uv : TEXCOORD0;
    float3 worldPos : TEXCOORD1;
    float3 worldNormal : TEXCOORD2;
};

float4 main(PSInput input) : SV_Target
{
    float3 albedo = tex.Sample(samp, input.uv).rgb * input.color.rgb;

    float3 N = normalize(input.worldNormal);
    float3 L = normalize(lightPos - input.worldPos);
    float3 V = normalize(viewPos - input.worldPos);
    float3 H = normalize(L + V);

    float diffuse = saturate(dot(N, L));
    float spec = pow(saturate(dot(N, H)), shininess);

    float3 final =
        0.1f * albedo +
        diffuse * albedo * lightColor +
        spec * lightColor;

    return float4(final, 1);
    //float4 texColor = tex.Sample(samp, input.uv);
    //return float4(input.uv, 0, 1);//红绿渐变uv-> 纹理采样器没绑上；纯色->寄存器或绑定顺序错了
}





/*Texture2D tex : register(t0);
SamplerState samp : register(s0);
cbuffer Light : register(b1)初学者还不用学
{
    float3 lightPos : packoffset(c0);
    float3 lightColor : packoffset(c1);
    float3 viewPos : packoffset(c2);
    float shininess : packoffset(c3);
}

struct PSInput
{
    float4 pos : SV_POSITION;
    float4 color : COLOR;
    float2 uv : TEXCOORD0;
    float3 worldPos : TEXCOORD1;
    float3 worldNormal : TEXCOORD2;
};

// 这里必须改成 main
float4 main(PSInput input) : SV_Target
{
    float3 albedo = tex.Sample(samp, input.uv).rgb * input.color.rgb;//albedo = 纹理颜色 * 顶点颜色

    float3 N = normalize(input.worldNormal);
    float3 L = normalize(lightPos - input.worldPos);
    float3 V = normalize(viewPos - input.worldPos);
    float3 H = normalize(L + V); // Blinn-Phong 半角向量

    // 漫反射
    float diffuse = saturate(dot(N, L));

    // 高光 (Blinn-Phong)
    float spec = pow(saturate(dot(N, H)), shininess);

    float3 final =
        0.1f * albedo +                  // 环境光
        diffuse * albedo * lightColor +  // 漫反射
        spec * lightColor;               // 高光
    //return float4(1,1,1,1);
    //return float4(final, 1);
    //return float4(input.worldNormal * 0.5 + 0.5, 1);
    //return float4(final = 1.0f * albedo,1); // 纯环境光
    float4 texColor = tex.Sample(samp, input.uv);
    return texColor;
}*/
