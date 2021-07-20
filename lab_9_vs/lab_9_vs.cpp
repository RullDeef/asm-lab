#include <iostream>
#include <iomanip>
#include <chrono>

constexpr size_t N = 100000;

// OPERATION: (a + b) * (a - c)

float operate_floats(float a, float b, float c)
{
    float f;

    for (size_t i = 0; i < N; i++)
    {
        f = (a + b) * (a - c);
    }

    return f;
}

double operate_doubles(double a, double b, double c)
{
    double f;

    for (size_t i = 0; i < N; i++)
    {
        f = (a + b) * (a - c);
    }

    return f;
}

long double operate_long_doubles(long double a, long double b, long double c)
{
    long double f;

    for (size_t i = 0; i < N; i++)
    {
        f = (a + b) * (a - c);
    }

    return f;
}

float asm_operate_floats(float a, float b, float c)
{
    float f;
    short CR;

    __asm
    {
        finit

        fstcw word ptr [CR]
        and CR, 0011111111b
        fldcw word ptr [CR]
    }

    for (size_t i = 0; i < N; i++)
    {
        __asm
        {
            fld dword ptr [a]   // a
            fadd dword ptr [b]  // (a + b)

            fld dword ptr [a]   // a, (a + b)
            fsub dword ptr [c]  // (a - c), (a + b)

            fmul                // (a + b) * (a - c)
            fstp dword ptr [f]
        }
    }

    return f;
}

double asm_operate_doubles(double a, double b, double c)
{
    double f;
    short CR;

    __asm
    {
        finit

        fstcw word ptr[CR]
        and CR, 0011111111b
        or CR, 1011111111b
        fldcw word ptr[CR]
    }

    for (size_t i = 0; i < N; i++)
    {
        __asm
        {
            fld qword ptr[a]   // a
            fadd qword ptr[b]  // (a + b)

            fld qword ptr[a]   // a, (a + b)
            fsub qword ptr[c]  // (a - c), (a + b)

            fmul                // (a + b) * (a - c)
            fstp qword ptr[f]
        }
    }

    return f;
}

long double asm_operate_long_doubles(long double a, long double b, long double c)
{
    long double f;

    __asm { finit }

    for (size_t i = 0; i < N; i++)
    {
        __asm
        {
            fld qword ptr[a]   // a
            fadd qword ptr[b]  // (a + b)

            fld qword ptr[a]   // a, (a + b)
            fsub qword ptr[c]  // (a - c), (a + b)

            fmul                // (a + b) * (a - c)
            fstp qword ptr[f]
        }
    }

    return f;
}

void test_sin(long double pi)
{
    long double pi2 = pi / 2;
    long double sin_pi;
    long double sin_pi2;
    __asm
    {
        finit
        fld pi
        fsin
        fstp sin_pi
        fld pi2
        fsin
        fstp sin_pi2
    }

    std::cout << "sin( x ) = " << std::setprecision(2) << sin_pi << std::endl;
    std::cout << "sin(x/2) = " << std::setprecision(40) << sin_pi2 << std::endl;
}

int main()
{
#if 1
    srand(time(NULL));
    long double a = rand() % 100;
    long double b = rand() % 100;
    long double c = rand() % 100;

    {
        std::cout << "\noperate_floats:\n";
        auto start = std::chrono::system_clock::now();
        auto res = operate_floats(a, b, c);
        auto end = std::chrono::system_clock::now();
        std::cout << "time: " << std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count() / double(N) << std::endl;
        // std::cout << "res: " << res << std::endl;
    }

    {
        std::cout << "\nasm_operate_floats:\n";
        auto start = std::chrono::system_clock::now();
        auto res = asm_operate_floats(a, b, c);
        auto end = std::chrono::system_clock::now();
        std::cout << "time: " << std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count() / double(N) << std::endl;
        // std::cout << "res: " << res << std::endl;
    }

    {
        std::cout << "\noperate_doubles:\n";
        auto start = std::chrono::system_clock::now();
        auto res = operate_doubles(a, b, c);
        auto end = std::chrono::system_clock::now();
        std::cout << "time: " << std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count() / double(N) << std::endl;
        // std::cout << "res: " << res << std::endl;
    }

    {
        std::cout << "\nasm_operate_doubles:\n";
        auto start = std::chrono::system_clock::now();
        auto res = asm_operate_doubles(a, b, c);
        auto end = std::chrono::system_clock::now();
        std::cout << "time: " << std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count() / double(N) << std::endl;
        // std::cout << "res: " << res << std::endl;
    }

    {
        std::cout << "\noperate_long_doubles:\n";
        auto start = std::chrono::system_clock::now();
        auto res = operate_long_doubles(a, b, c);
        auto end = std::chrono::system_clock::now();
        std::cout << "time: " << std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count() / double(N) << std::endl;
        // std::cout << "res: " << res << std::endl;
    }

    {
        std::cout << "\nasm_operate_long_doubles:\n";
        auto start = std::chrono::system_clock::now();
        auto res = asm_operate_long_doubles(a, b, c);
        auto end = std::chrono::system_clock::now();
        std::cout << "time: " << std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count() / double(N) << std::endl;
        // std::cout << "res: " << res << std::endl;
    }

    std::cout << std::endl;
#endif
    // test sin(pi)
    {
        long double fpu_pi;
        __asm
        {
            finit
            fldpi
            fstp fpu_pi
        }

        std::cout << "x = FPU PI = " << std::setprecision(17) << fpu_pi << std::endl;
        test_sin(fpu_pi);
        std::cout << "x = 3.14\n";
        test_sin(3.14);
        std::cout << "x = 3.141596\n";
        test_sin(3.141596);
    }

    return 0;
}
