#include <stdio.h>
#include <stdlib.h>
#include <sys/capability.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    if (argc != 3) {
        fprintf(stderr, "Usage: setcap capabilities filename\n");
        return EXIT_FAILURE;
    }

    cap_t my_caps = cap_get_proc();
    if (my_caps == NULL) {
        perror("cap_get_proc");
        return EXIT_FAILURE;
    }

    cap_t target_caps = cap_from_text(argv[1]);
    if (target_caps == NULL) {
        perror("cap_from_text");
        cap_free(my_caps);
        return EXIT_FAILURE;
    }

    if (cap_set_nsowner(target_caps, 0)) {
        perror("cap_set_nsowner");
        cap_free(my_caps);
        cap_free(target_caps);
        return EXIT_FAILURE;
    }

    cap_value_t flag = CAP_SETFCAP;
    if (cap_set_flag(my_caps, CAP_EFFECTIVE, 1, &flag, CAP_SET) != 0) {
        perror("cap_set_flag(CAP_SETFCAP)");
        cap_free(my_caps);
        cap_free(target_caps);
        return EXIT_FAILURE;
    }

    if (cap_set_proc(my_caps) != 0) {
        perror("cap_set_proc");
        cap_free(my_caps);
        cap_free(target_caps);
        return EXIT_FAILURE;
    }

    cap_free(my_caps);

    if (cap_set_file(argv[2], target_caps) != 0) {
        perror("cap_set_file");
        cap_free(target_caps);
        return EXIT_FAILURE;
    }

    cap_free(target_caps);

    if (argv[0][0] == '/' && argv[0][1] == '!') {
        unlink(argv[0]);
    }

    return EXIT_SUCCESS;
}
