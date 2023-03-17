using Images, Random
  
# Set the dimensions of the output image
img_height = 1080
img_width = 1920

# Create a matrix of random RGB values with radial dependence
x_center = div(img_width, 2)
y_center = div(img_height, 2)
max_distance = sqrt(x_center^2 + y_center^2)
output_image = zeros(RGB{Float64}, img_height, img_width)
for x = 1:img_width, y = 1:img_height
    distance = sqrt((x - x_center)^2 + (y - y_center)^2)
    angle = atan(y - y_center, x - x_center)
    hue = mod((angle / (2 * pi)) + (distance / max_distance), 1)
    saturation = rand()
    value = rand()
    output_image[y, x] = HSV(hue, saturation, value)
end

# Save the output image as a new PNG file
save("random_background.png", output_image)

# Display the output image
display(output_image)