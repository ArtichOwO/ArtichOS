#!python3

import argparse
import binascii
import struct


HEADER_KEYS = {
    "BS_jmpBoot":     {"struct": "3s", "type": bytes},
    "BS_OEMName":     {"struct": "8s", "type": str},
    "BPB_BytsPerSec": {"struct": "H", "type": int},
    "BPB_SecPerClus": {"struct": "B", "type": int},
    "BPB_RsvdSecCnt": {"struct": "H", "type": int},
    "BPB_NumFATs":    {"struct": "B", "type": int},
    "BPB_RootEntCnt": {"struct": "H", "type": int},
    "BPB_TotSec16":   {"struct": "H", "type": int},
    "BPB_Media":      {"struct": "B", "type": hex},
    "BPB_FATSz16":    {"struct": "H", "type": int},
    "BPB_SecPerTrk":  {"struct": "H", "type": int},
    "BPB_NumHeads":   {"struct": "H", "type": int},
    "BPB_HiddSec":    {"struct": "I", "type": int},
    "BPB_TotSec32":   {"struct": "I", "type": int},
    "BS_DrvNum":      {"struct": "B", "type": hex},
    "BS_Reserved1":   {"struct": "c", "type": None},
    "BS_BootSig":     {"struct": "B", "type": hex},
    "BS_VolID":       {"struct": "I", "type": hex},
    "BS_VolLab":      {"struct": "11s", "type": str},
    "BS_FilSysType":  {"struct": "8s", "type": str},
    "BootCode":       {"struct": "448s", "type": None},
    "Signature":      {"struct": "2s", "type": bytes}
}


def parse_header(header_binary: bytes) -> dict:
    values = struct.unpack(
        "<" + "".join([key["struct"] for key in HEADER_KEYS.values()]),
        header_binary)

    return dict(zip(HEADER_KEYS.keys(), values))


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("binary")

    parser.add_argument(
        "--parse-header",
        action = "store_true"
    )

    parser.add_argument(
        "--export-kernel",
        nargs = 1
    )

    args = parser.parse_args()

    if args.parse_header:
        with open(args.binary, "rb") as file:
            for key in (header := parse_header(file.read()[:512])):
                field_type = HEADER_KEYS[key]['type']

                if field_type is not None:
                    if field_type == str:
                        value = f"\"{header[key].decode('ascii')}\""
                    elif field_type == bytes:
                        value = binascii.hexlify(header[key])
                    else:
                        value = field_type(header[key])

                    print(f"{key}: {value}")

    if args.export_kernel is not None:
        with open(args.binary, "rb") as file, open(args.export_kernel[0], "wb") as output_file:
            output_file.write(file.read()[512:])
