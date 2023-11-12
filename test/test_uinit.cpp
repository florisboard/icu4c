#include <unicode/uclean.h>
#include <unicode/utypes.h>
#include <iostream>

int main(int argc, char** argv) {
    UErrorCode status = U_ZERO_ERROR;

    u_init(&status);
    if (U_SUCCESS(status)) {
        std::cout << "Successfully executed u_init()" << std::endl;
        return 1;
    } else {
        std::cout << "Failed to execute u_init(): " << u_errorName(status) << std::endl;
        return 1;
    }

    return 0;
}
