
float add_floats(float a, float b)
{
    float c;

    c = a + b;
    c = a * c;

    return c;
}

double add_doubles(double a, double b)
{
    double c;

    c = a + b;
    c = a * c;

    return c;
}

void _asm_add_floats(float a, float b)
{
    long double c = 0;

    __asm__ (
        "finit"             "\n\t"
        "fld ptr %0"        "\n\t"
        : "=rm" (c)
        : "rm" (a), "rm" (b)
    );
}

int main(void) {

    return 0;
}
