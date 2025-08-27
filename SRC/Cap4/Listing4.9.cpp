#include <pthread.h>
#include <iostream>

class ThreadExitException
{
public:
    explicit ThreadExitException(void* return_value)
        : thread_return_value_(return_value) {}

    void* DoThreadExit()
    {
        pthread_exit(thread_return_value_);
    }

private:
    void* thread_return_value_;
};

// Prototipo
bool should_exit_thread_immediately();

void do_some_work()
{
    int i = 0;
    while (true) {
        std::cout << "[Hilo] Iteración " << i++ << " trabajando...\n";
        if (should_exit_thread_immediately())
            throw ThreadExitException(nullptr); 
    }
}

void* thread_function(void*)
{
    try {
        do_some_work();
    }
    catch (ThreadExitException& ex) {
        std::cout << "[Hilo] Se lanzó excepción de salida.\n";
        ex.DoThreadExit();
    }
    return nullptr;
}

// Ejemplo dummy: después de 10 iteraciones el hilo sale
bool should_exit_thread_immediately() {
    static int counter = 0;
    counter++;
    return counter > 10;
}

int main()
{
    pthread_t thread;
    pthread_create(&thread, nullptr, thread_function, nullptr);
    pthread_join(thread, nullptr);
    std::cout << "[Main] Thread finalizó correctamente.\n";
    return 0;
}

