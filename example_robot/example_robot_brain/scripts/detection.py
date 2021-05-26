#!/usr/bin/env python

import numpy as np

# Does not actually detect anything, just returns hardcoded locations
def obj_mapper():
    # detect weeds
    weed_placements = np.array([[1, 2], [2, 2]])

    # detect weeds
    litter_placements = np.array([[2, 1], [2, 1]])

    return weed_placements, litter_placements
