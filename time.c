#include <time.h>

struct tm GetLocalTime()
{
    time_t timer = time(NULL);
    return *localtime(&timer);
}

// Interface for Nim
int getYear() { return GetLocalTime().tm_year; }
int getMonth() { return GetLocalTime().tm_mon + 1; }
int getDay() { return GetLocalTime().tm_mday; }
int getHour() { return GetLocalTime().tm_hour; }
int getMinute() { return GetLocalTime().tm_min; }
int getSecond() { return GetLocalTime().tm_sec; }
