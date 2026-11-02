import random
from pydantic import BaseModel
import math

class Vector(BaseModel):
    values: list[float]
    weight: float = 1.0
    tag: str | None = None

    def distance_to(self, p: Vector) -> float:
        sum_squares = 0
        for i in range(len(p.values)):
            sum_squares += (p.values[i] - self.values[i]) * (p.values[i] - self.values[i])
        return math.sqrt(sum_squares)

def average(pts: list[Vector]) -> Vector:
    assert len(pts) != 0, "Can't average 0 elements"

    dims = len(pts[0].values)
    values = [0.0] * dims
    weight_sum = 0
    for p in pts:
        weight_sum += p.weight
        for i in range(dims):
            values[i] += p.weight * p.values[i]

    for i in range(dims):
        values[i] /= weight_sum

    return Vector(values=values)

class KMeans:
    def __init__(self, points: list[Vector], k: int, centroids: list[Vector] | None, seed: int) -> None:
        self.current_iteration: int = 0
        self.current_delta_diff : float = 0
        self.points = points
        self.k = k
        self.rng = random.Random(seed)
        self.points_per_category: list[list[Vector]] = [[] for _ in range(k)]

        if centroids:
            self.centroids = centroids
        else:
            self.centroids = self.rng.sample(self.points, k)
    
    def step(self):
        for i in range(self.k): # clear category
            self.points_per_category[i] = []

        # calc points per centroid
        
        

