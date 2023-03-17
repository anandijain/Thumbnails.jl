
using Images, LinearAlgebra
using ImageSegmentation
using OpenAIReplMode

import ImageSegmentation.segment

# Load the two images
image1 = load("data/openai.png")
image2 = load("data/arm.png")

# Determine the position of the second image
desired_width = div(size(image1, 2), 2)
scale_factor = min(desired_width / size(image2, 2), 1.0)
resized_image2 = imresize(image2, (round(Int, scale_factor * size(image2, 1)), round(Int, scale_factor * size(image2, 2))))

x = size(image1, 2) + div(size(image1, 2) - size(resized_image2, 2), 2)
y = div(size(image1, 1) - size(resized_image2, 1), 2)

# Remove the background of the second image
mask = Gray.(channelview(resized_image2) .!= 0)
# mask = openunitinterval.(mask)
resized_image2 = RGB.(channelview(resized_image2) .* mask)

# Attach the modified second image to the right of the first image
result = hcat(image1, fill(RGB(0, 0, 0), size(image1, 1), x-size(image1, 2)), resized_image2)

# Flip and attach the modified second image to the left of the first image
flipped = flipdim(resized_image2, 2)
result = hcat(flipped, fill(RGB(0, 0, 0), size(result, 1), div(size(result, 2) - size(flipped, 2), 2)), result)

