from math import log2

_suffixes = ['B', 'KB', 'MB', 'GB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB']

def file_size(size):
    # determine binary order in steps of size 10 
    # (coerce to int, // still returns a float)
    order = int(log2(size) / 10) if size else 0
    # format file size
    # (.4g results in rounded numbers for exact matches and max 3 decimals, 
    # should never resort to exponent values)
    return '{:.4g}\n{}'.format(size / (1 << (order * 10)), _suffixes[order])