using Images
  
# Set the dimensions of the output image
img_height = 1080
img_width = 1920

# Create a matrix of RGB values with radial dependence based on distance from the center
x_center = div(img_width, 2)
y_center = div(img_height, 2)
max_distance = sqrt(x_center^2 + y_center^2)
output_image = zeros(RGB{Float64}, img_height, img_width)
for x = 1:img_width, y = 1:img_height
    distance = sqrt((x - x_center)^2 + (y - y_center)^2)
    red = 1 - distance / max_distance
    green = distance / max_distance
    blue = max(0.5, 0.8 - distance / max_distance)
    output_image[y, x] = RGB(red, green, blue)
end

# Save the output image as a new PNG file
# save("radial_background.png", output_image)

# Display the output image
display(output_image)
