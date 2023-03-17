using Images
using OpenAIReplMode

# Set the dimensions of the output image
img_height = 1080
img_width = 1920

img_height = 1080 ÷ 2
img_width = 1920 ÷ 2

# Set the number of frames and calculate the frame delta
num_frames = 30
frame_delta = 2 * pi / num_frames

# Create a folder to store each frame
if !isdir("anim2")
    mkdir("anim2")
end

# Generate a new radial background for each frame and save it as a PNG file
output_image = zeros(RGB{Float64}, img_height, img_width)
i = 1
# for i = 1:num_frames
function generate_frame(output_image, i)
    # Create a matrix of RGB values with radial dependence based on distance from the center
    x_center = div(img_width, 2)
    y_center = div(img_height, 2)
    max_distance = sqrt(x_center^2 + y_center^2)
    for x = 1:img_width, y = 1:img_height
        distance = sqrt((x - x_center)^2 + (y - y_center)^2)
        red = sin(i * frame_delta + distance / max_distance) / 2 + 0.5
        green = sin(i * frame_delta + distance / max_distance + 2 * pi / 3) / 2 + 0.5
        blue = sin(i * frame_delta + distance / max_distance + 4 * pi / 3) / 2 + 0.5
        output_image[y, x] = RGB(red, green, blue)
    end
    output_image
end

for i = 1:num_frames
    generate_frame(output_image, i)
    filename = "anim2/frame_" * string(i) * ".png"
    save(filename, output_image)
    print("Frame ", i, "/", num_frames, "\r")
    flush(stdout)
end

run(`ffmpeg -r $frame_rate -f image2 -s $(img_width)x$(img_height) -i anim2/frame_%d.png -vcodec libx264 -crf 25 -pix_fmt yuv420p -n wave_animation.mp4`)
