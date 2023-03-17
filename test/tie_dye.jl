using Images
  
function tie_dye(image)
    h, w = size(image)

    # create a random noise image with the same size as the input image
    noise = randn(h, w)

    # define the colors for the tie-dye effect
    colors = [
        RGB(1.0, 0.0, 0.0),  # red
        RGB(1.0, 0.5, 0.0),  # orange
        RGB(1.0, 1.0, 0.0),  # yellow
        RGB(0.0, 1.0, 0.0),  # green
        RGB(0.0, 1.0, 1.0),  # cyan
        RGB(0.0, 0.0, 1.0),  # blue
        RGB(1.0, 0.0, 1.0)   # magenta
    ]

    # initialize the output image with a black background
    output = zeros(RGB{Float64}, h, w)

    # apply the tie-dye effect by mapping the noise image to the color palette
    for i = 1:length(colors)
        output += (noise .< (i/length(colors))) .* colors[i]
    end

    # combine the input image with the tie-dye effect using a blend operation
    output = blend(output, image)

    return output
end

function blend(bottomlayer::AbstractArray, toplayer::AbstractArray)
    # initialize the output image
    output = zeros(eltype(bottomlayer), size(bottomlayer))

    # blend the two images using alpha composite
    α = toplayer[:, :, end] ./ maximum(norm.(toplayer[:, :, end]))
    output = bottomlayer .* (1 .- α) .+ toplayer .* α

    return output
end


logo = load("data/openai.png")
logo_tie_dye = tie_dye(logo)
display(logo_tie_dye)


logo = load("data/openai.png")
logo_tie_dye = tie_dye(logo)
background = load("data/bg.png")
background = resize(background, (1080, 1920))

xc = div(size(background, 2) - size(logo_tie_dye, 2), 2)
yc = div(size(background, 1) - size(logo_tie_dye, 1), 2)

# blend the tie-dyed logo with the background
background[yc:yc+size(logo_tie_dye, 1)-1, xc:xc+size(logo_tie_dye, 2)-1, :] = blend(background[yc:yc+size(logo_tie_dye, 1)-1, xc:xc+size(logo_tie_dye, 2)-1, :], logo_tie_dye)

display(background)

using Colors
  
using Colors, ColorVectorSpace

using Images
  



logo = load("data/openai.png")
h, w = size(logo)

# initialize the output logo
output = zeros(RGB{Float64}, h, w)

# calculate the rainbow color gradient
gradient = [RGB(i/w, 1, 1) for i in 1:w]

# go through every pixel of the input logo and apply the rainbow color if the pixel is not transparent
for x = 1:w, y = 1:h
    if logo[y,x].alpha > 0
        output[y,x,:] .= gradient[x]
    end
end

display(output)

using Images
  
# Load the input image
input_image = load("data/openai.png")

# Initialize the output image with the same size as the input image
output_image = zeros(RGBA{Float64}, size(input_image))

# Extract the alpha channel from the input image
alpha_channel = map(x->x.alpha, input_image)

# Create an alpha channel mask for the output image
mask = alpha_channel .> 0

# Calculate the rainbow color gradient
gradient = [RGB(mod((i/size(input_image, 2)) * 2, 1), 1, 1) for i in 1:size(input_image, 2)]

# Go through every pixel of the input image and apply the rainbow color if the pixel is not transparent
for x = 1:size(input_image, 2), y = 1:size(input_image, 1)
    if mask[y, x]
        output_image[y, x, 1:3] = gradient[x]
        output_image[y, x, 4] = alpha_channel[y, x]
    end
end

# Save the output image as a new PNG file
save("data/openai_rainbow.png", output_image)

# Display the output image
display(output_image)