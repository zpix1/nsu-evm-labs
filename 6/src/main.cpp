#include <stdio.h>

#include "libusb.h"

void print_head() {
    printf("===========================================================\n");
    printf("* количество возможных конфигураций\n");
    printf("|  * класс устройства\n");
    printf("|  |  * идентификатор производителя\n");
    printf("|  |  |    * идентификатор устройства\n");
    printf("|  |  |    |    * количество интерфейсов\n");
    printf("|  |  |    |    |   * количество альтернативных настроек\n");
    printf("|  |  |    |    |   |  *  класс устройства\n");
    printf("|  |  |    |    |   |  |  * номер интерфейса\n");
    printf("|  |  |    |    |   |  |  |  * количество конечных точек\n");
    printf("|  |  |    |    |   |  |  |  |  * тип дескриптора\n");
    printf("|  |  |    |    |   |  |  |  |  |  * адрес конечной точки\n");
    printf("+--+--+----+----+---+--+--+--+--+--+----------------------\n");
}

void printdev(libusb_device *dev) {
    libusb_device_descriptor desc;
    libusb_config_descriptor *config;
    const libusb_interface *inter;
    const libusb_interface_descriptor *interdesc;
    const libusb_endpoint_descriptor *epdesc;

    unsigned char string[256];
    int r;

    r = libusb_get_device_descriptor(dev, &desc);
    if (r < 0) {
        fprintf(stderr, "Ошибка: дескриптор устройства не получен, код: %d.\n", r);
        return;
    }
    print_head();
    libusb_get_config_descriptor(dev, 0, &config);
    printf("%.2d %.2d %.4d %.4d %.3d |  |  |  |  |  |\n", (int)desc.bNumConfigurations, (int)desc.bDeviceClass, desc.idVendor, desc.idProduct, (int)config->bNumInterfaces);
    for (int i = 0; i < (int)config->bNumInterfaces; i++) {
        inter = &config->interface[i];
        printf("|  |  |    |    |   %.2d %.2d |  |  |  |\n", inter->num_altsetting, (int)desc.bDeviceClass);
        for (int j = 0; j < inter->num_altsetting; j++) {
            interdesc = &inter->altsetting[j];
            printf("|  |  |    |    |   |  |  %.2d %.2d |  |\n", (int)interdesc->bInterfaceNumber, (int)interdesc->bNumEndpoints);
            for (int k = 0; k < (int)interdesc->bNumEndpoints; k++) {
                epdesc = &interdesc->endpoint[k];
                printf("|  |  |    |    |   |  |  |  |  %.2d %.9d\n", (int)epdesc->bDescriptorType, (int)epdesc->bEndpointAddress);
            }
        }
    }
    libusb_free_config_descriptor(config);

    libusb_device_handle *handle = NULL;
    libusb_open(dev, &handle);
    if (handle) {
        if (desc.iManufacturer) {
            r = libusb_get_string_descriptor_ascii(handle, desc.iManufacturer, string, sizeof(string));
            if (r > 0)
                printf("Производитель: %s\n", (char *)string);
        }

        if (desc.iProduct) {
            r = libusb_get_string_descriptor_ascii(handle, desc.iProduct, string, sizeof(string));
            if (r > 0)
                printf("Продукт: %s\n", (char *)string);
        }

        if (desc.idVendor) {
            r = libusb_get_string_descriptor_ascii(handle, desc.idVendor, string, sizeof(string));
            if (r > 0)
                printf("Производитель (another): %s\n", (char *)string);
        }

        if (desc.idProduct) {
            r = libusb_get_string_descriptor_ascii(handle, desc.idProduct, string, sizeof(string));
            if (r > 0)
                printf("Продукт (another): %s\n", (char *)string);
        }

        if (desc.iSerialNumber) {
            r = libusb_get_string_descriptor_ascii(handle, desc.iSerialNumber, string, sizeof(string));
            if (r > 0)
                printf("Серийный номер: %s\n", (char *)string);
        }
    }
    if (handle)
        libusb_close(handle);
}

int main() {
    libusb_device **devs;       // указатель на указатель на устройство
    libusb_context *ctx = NULL; // контекст сессии libusb
    int r;                      // для возвращаемых значений
    ssize_t cnt;                // число найденных USB-устройств
    ssize_t i;                  // индексная переменная цикла переборавсех устройств// инициализировать библиотеку libusb,открыть сессию работы с libusb
    r = libusb_init(&ctx);
    if (r < 0) {
        fprintf(stderr, "Ошибка: инициализация не выполнена, код: %d.\n", r);
        return 1;
    }
    libusb_set_debug(ctx, 3);
    cnt = libusb_get_device_list(ctx, &devs);
    if (cnt < 0) {
        fprintf(stderr, "Ошибка: список USB устройств не получен.\n", r);
        return 1;
    }
    printf("Найдено устройств: %d\n", cnt);

    for (i = 0; i < cnt; i++) {
        printf("Устройство %d\\%d\n", i + 1, cnt);
        printdev(devs[i]);
    }
    printf("===========================================================\n");
    libusb_free_device_list(devs, 1);
    libusb_exit(ctx);
    return 0;
}
