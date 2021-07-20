#include <iostream>
#include <chrono>

using namespace std::chrono;

constexpr size_t N = 10000;

struct vec4
{
    float data[4];
};

float dot(const vec4& a, const vec4& b)
{
    float res;

    for (size_t i = 0; i < N; i++)
        res = a.data[0] * b.data[0]
            + a.data[1] * b.data[1]
            + a.data[2] * b.data[2]
            + a.data[3] * b.data[3];

    return res;
}

float dot_asm(vec4 a, vec4 b)
{
    vec4 res;

    for (size_t i = 0; i < N; i++)
        asm(
            "movups %[a], %%xmm0"                "\n\t" // xmm0 = a.x     a.y     a.z     a.w
            "movups %[b], %%xmm1"                "\n\t" // xmm1 = b.x     b.y     b.z     b.w
            "mulps %%xmm1, %%xmm0"               "\n\t" // xmm0 = a.x*b.x a.y*b.y a.z*b.z a.w*b.w
            "movhlps %%xmm0, %%xmm1"             "\n\t" // xmm1 = a.z*b.z a.w*b.w ------- ------- 
            "addps %%xmm1, %%xmm0"               "\n\t" // xmm0 = XX+ZZ   YY+WW   ------- -------
            "shufps $0b11011000, %%xmm0, %%xmm0" "\n\t" // xmm0 = XX+ZZ   ------- YY+WW   -------
            "movhlps %%xmm0, %%xmm1"             "\n\t" // xmm1 = YY+WW   ------- ------- -------
            "addps %%xmm1, %%xmm0"               "\n\t" // xmm0 = (a,b)   ------- ------- -------
            "movss %%xmm0, %[res]"               "\n\t"
            : [res]"=rm"(res)           // output
            : [a]"rm"(a), [b]"rm"(b)    // input
            :
        );

    return res.data[0];
}

int main()
{
    vec4 a = { 1.0f, 2.0f, 3.0f, 4.0f };
    vec4 b = { 5.0f, 6.0f, 7.0f, 8.0f };

    float res_1, res_2;

    {
        auto start = system_clock::now();
        res_1 = dot(a, b);
        auto end = system_clock::now();
        auto time = duration_cast<nanoseconds>(end - start);
        std::cout << "cpp time: " << time.count() / double(N) << "ns" << std::endl;
    }

    {
        auto start = system_clock::now();
        res_2 = dot_asm(a, b);
        auto end = system_clock::now();
        auto time = duration_cast<nanoseconds>(end - start);
        std::cout << "asm time: " << time.count() / double(N) << "ns" << std::endl;
    }

    std::cout << "results:\n\tcpp = " << res_1
            << "\n\tasm = " << res_2 << std::endl;

    return 0;
}
