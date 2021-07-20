#include <iostream>
using namespace std;

extern "C" int copy_string(const char* source, char* dest, int size);

int string_length(const char* string)
{
    __asm {
        xor eax, eax
        mov ecx, -1

        mov edi, string
        repne scasb

        not ecx
        dec ecx
        mov eax, ecx
    }
}

int main()
{
    const char* string = "test string";

    cout << "test string: \"" << string << "\"" << endl;
    cout << "string length: " << string_length(string) << endl;
    cout << endl << "testing copy_string: " << endl;

    char dest[] = "much much longer string here";

    for (int i = 0; i < sizeof(dest) / sizeof(char); i++)
        if (dest[i] == '\0')
            cout << "_";
        else
            cout << dest[i];
    cout << endl;

    copy_string(string, dest, string_length(string));
    for (int i = 0; i < sizeof(dest) / sizeof(char); i++)
        if (dest[i] == '\0')
            cout << "_";
        else
            cout << dest[i];
    cout << endl;

    copy_string(dest + 6, dest, 6);
    for (int i = 0; i < sizeof(dest) / sizeof(char); i++)
        if (dest[i] == '\0')
            cout << "_";
        else
            cout << dest[i];
    cout << endl;

    __asm xor eax, eax
}
