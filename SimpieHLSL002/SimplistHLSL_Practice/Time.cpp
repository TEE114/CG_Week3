#include "Time.h"

bool isRotate = true;
float angle = 0;

// 全局
LARGE_INTEGER freq, lastTime;
float deltaTime;
// 初始化（程序启动）
void InitTimer()
{
	QueryPerformanceFrequency(&freq);
	QueryPerformanceCounter(&lastTime);
}


// 渲染循环里每帧执行
void UpdateTimer()
{
	LARGE_INTEGER currTime;
	QueryPerformanceCounter(&currTime);

	deltaTime = (currTime.QuadPart - lastTime.QuadPart) / (float)freq.QuadPart;

	lastTime = currTime;
	// 用 deltaTime 旋转纹理

	angle += deltaTime * 120.0f;
}