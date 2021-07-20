@Cstr MACRO arg

LOCAL temp,i,x,string,lbl,t

    i=1
    x TEXTEQU <>
    string TEXTEQU <db >

    x CATSTR arg,< >

    n SIZESTR x
    n=n-1

    WHILE n

        temp    TEXTEQU @SubStr(x,i,2)

        t=1

        IFIDNI  temp,<\!t>

            string  CATSTR string,<",9,">

        ELSEIFIDNI  temp,<\n>
        
            string  CATSTR string,<",13,10,">

        ELSEIFIDNI  temp,<\q>   ; \q for double CR+LF

            string  CATSTR string,<",13,10,13,10,">

        ELSEIFIDNI  temp,<\\>

            string  CATSTR string,<\>

        ELSE

            string  CATSTR string,@SubStr(x,i,1)
            t=0
            
        ENDIF

    i=i+1+t
    n=n-1-t

    ENDM

    strsize SIZESTR string

    IFIDNI  @SubStr(string,strsize-1,2),<"">

        string  SUBSTR string,1,strsize-3    ; remove unnecessary
                                             ; double quotes
    ENDIF

    string  CATSTR string,<,0>

    .data

    lbl     string

    .code

EXITM <OFFSET lbl>

ENDM
