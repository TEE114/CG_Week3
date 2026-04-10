
cbuffer MVPBuffer : register(b0)
{
    matrix model;
    matrix view;
    matrix proj;
    float4x4 texRot;
}
// Constant buffer for Model-View-Projection matrices

struct VSInput
{
    float3 pos : POSITION;
    float4 color : COLOR;
    float2 uv : TEXCOORD0;
};

struct PSInput
{
    float4 pos : SV_POSITION;
    float4 color : COLOR;
    float2 uv : TEXCOORD0;
    float3 worldPos : TEXCOORD1;
    float3 worldNormal : TEXCOORD2;
};

PSInput main(VSInput input)
{
    PSInput output;
    float4 p = float4(input.pos, 1.0f);
    p = mul(p, model);
    p = mul(p, view);
    p = mul(p, proj);
// 简单近似法线（立方体可用）
    float3 worldNormal = normalize(mul(input.pos, (float3x3)model));

    output.worldPos = mul(float4(input.pos,1), model).xyz;
    output.worldNormal = worldNormal;

// 旋转纹理坐标
    float2 uv = input.uv - 0.5f;
    uv = mul(float4(uv,0,1), texRot).xy;
    uv += 0.5f;
    output.uv = uv;

    output.pos = p;
    output.color = input.color;
    return output;
}