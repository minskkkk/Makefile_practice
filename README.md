# Makefile Practice
---

본 문서는 리눅스 환경에서 C프로그램 빌드의 기본적인 과정과 Makefile의 작성과 활용을 설명합니다.

목차는 다음과 같습니다.


1. C프로그램의 기본적인 빌드 과정
   - 본 문서에서 사용하는 파일의 개요 및 내용
   - C프로그램의 빌드 과정


2. Makefile의 구조와 작성
   - Makefile의 구조
   - Makefile의 작성
   - Makefile의 실행


3. Variable을 사용한 Makefile의 작성
   - Variable을 사용한 Makefile 예시
   - Automatic variables

4. Summary

---

### C프로그램의 기본적인 빌드 과정
#### 1. 본 문서에서 사용하는 파일의 개요 및 내용

__a.c__
```
#include <stdio.h>

void b()
{
  printf("This file is a.c\n");
}
```

__a.h__
```
void foo();
```

__b.c__
```
#include <stdio.h>

void b()
{
  printf("This file is b.c\n");
}
```

__b.h__
```
void b();
```

__main.c__
```
#include "a.h"
#include "b.h"
    
int main()
{
  a();
  b();

  return 0;
}
```


#### 2. C프로그램의 빌드 과정

1. 컴파일
     a.c, b.c, main.c 의 소스파일을 각각 컴파일하여 Object파일(*.o)을 생성합니다.

```
입력)

$gcc -c -o a.o a.c
$gcc -c -o b.o b.c
$gcc -c -o main.o main.c
```

2. 링크
    생성된 Object파일을 하나의 실행 파일인 a.out으로 묶는 과정입니다.

    링크 과정을 통해서 생성된 Object파일인 a.o, b.o, main.o 를 묶어 a.out을 생성합니다.

    이 과정에서 소스파일에 정의된 함수(a(), b())를 main에서 호출하는 의존성이 생깁니다.

```
입력)

$gcc -o a.out main.o a.o b.o
```

3. 실행
    
    이 과정에서 소스파일에 정의된 함수(a(), b())를 main에서 호출하는 의존성이 생깁니다.

```
입력)

$./a.out
```
```
출력)

This file is a.c
This file is b.c
```

### Makefile의 구조와 작성
#### Makefile의 구조

Makefile은 Target, Dependency, Recipe의 세가지로 구성됩니다.

Makefile structure)
```
<target> : <dependency>
  <Recipe>
```

- Target: 빌드 대상의 이름
  
    명령에 의해 생성되는 결과 파일 혹은 오브젝트 파일이나 실행 파일을 기술합니다.

  
- Dependency: 빌드 대상을 생성할 때, 의존되는 파일
  
    Makefile 실행 시 Dependency에 나열된 대상을 먼저 생성한 후, 빌드 대상을 생성합니다.


- Recipe: 빌드 대상을 생성하는 명령

#### Makefile의 작성

```
a.out : a.o b.o main.o
  gcc -o a.out a.o b.o main.o

a.o : a.c
  gcc -c -o a.o a.c
    
b.o : b.c
  gcc -c -o b.o b.c
    
main.o : main.c
  gcc -c -o main.o main.c
    
clean:
  rm *.o a.out
```

본 문서에서 사용되는 파일들로 Makefile을 작성할 때에는 위와 같이 작성합니다.


#### Makefile의 실행

```
입력)

$make
```

```
출력)

gcc -c -o a.o a.c
gcc -c -o b.o b.c
gcc -c -o main.o main.c
gcc -o a.out a.o b.o main.o
```

```
입력)

$ls
```

```
출력)

a.c a.h a.o a.out b.c b.h b.o main.c main.o Makefile
```

Makefile을 실행했을 때, 위와 같은 결과를 얻을 수 있습니다.


### Variable을 사용한 Makefile의 작성

#### Variable을 사용한 Makefile 예시

아래는 본 문서에서 사용하는 파일들을 빌드하기 위한 목적의 Makefile입니다.

변수를 사용하면 Makefile을 보다 깔끔하고, 확장성있게 작성할 수 있습니다.

변수들 중에는 Make 내부에서 사용하는 내장 변수와 확장성을 용이하게 해주는 자동 변수가 존재합니다.

```
CC=gcc
CFLAGS=-g -Wall
TARGET=a.out
OBJS=a.o b.o main.o
 
$(TARGET): $(OBJS)
    $(CC) -o $@ $(OBJS)

a.o : a.c
    $(CC) -c -o a.o a.c

b.o : b.c
    $(CC) -c -o b.o b.c

main.o : main.c
    $(CC) -c -o main.o main.c

clean:
    rm $(OBJECT) $(TARGET)
```

- CC: Compiler
- CFLAGS: Compile Options
- OBJS: Object file의 목록
- TARGET: 빌드 대상의 이름

#### Automatic variables


위 코드를 살펴보면 Recipe 중간에 정의한 적이 없는 변수인 __$@__ 이 포함되어 있습니다.

$@는 현재 빌드 규칙 블록의 Target 이름을 나타내는 자동 변수입니다.

자동 변수는 위치한 곳의 맥락에 맞도록 자동으로 치환됩니다.

즉, 위 코드의 __$@__ 는 Recipe을 실행할 때 $(TARGET) 으로 자동 치환됩니다.




__Make에서 지원하는 대표적인 자동 변수들은 다음과 같습니다__

- $@: 현재 Target 이름
- $^: 현재 Target이 의존하는 대상들의 전체 목록
- $?: 현재 Target이 의존하는 대상들 중 변경된 것들의 목록
- $%: 대상의 이름



__사용 가능한 자동 변수들은 [해당 사이트](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html)에서 확인할 수 있습니다.__



### Summary

Makefile 기본 패턴)

```
CC=<컴파일러>
CFLAGS=<컴파일 옵션>
LDFLAGS=<링크 옵션>
LDLIBS=<링크 라이브러리 목록>
OBJS=<Object 파일 목록>
TARGET=<빌드 대상 이름>
 
all: $(TARGET)
 
clean:
    rm -f *.o
    rm -f $(TARGET)
 
$(TARGET): $(OBJS)
$(CC) -o $@ $(OBJS)
```






