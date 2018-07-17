#pragma once

#include "Raetan.hpp"
#include "IObject.hpp"
#include "Sampler.hpp"

class	Cone : public IObject
{
	glm::dvec2	solveQuadratic(double a, double b, double c) const;
	glm::dvec3	findNormal(const glm::dvec3& intersection, const Ray& ray) const;
	std::vector<std::pair<double, IObject*>> findDistances(const Ray& ray) const;
	glm::dvec2	uvMap(const glm::dvec3& intersection, const glm::dvec3& normal) const;

public:
	double			angle;
	glm::dvec3		vector;

	RayResult MakeRayResult(double distance, const Ray& ray) const;
};