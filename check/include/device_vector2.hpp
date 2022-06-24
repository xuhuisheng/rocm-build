
#pragma once

class device_vector2 
{

public:
    explicit device_vector2(size_t n)
    {
	hipMalloc(&m_data, sizeof(float) * n);
    }

    ~device_vector2()
    {
	hipFree(m_data);
        m_data = nullptr;
    }

    operator float*()
    {
        return m_data;
    }

    operator const float*() const
    {
        return m_data;
    }

private:
    float*          m_data{};
};
