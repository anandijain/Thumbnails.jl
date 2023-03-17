using Images
using OpenAIReplMode

# Set the dimensions of the output image
img_height = 1080 ÷ 2
img_width = 1920 ÷ 2

# Set the number of frames and calculate the frame delta
num_frames = 30
frame_delta = 2 * pi / num_frames

# Create a folder to store each frame
if !isdir("anim2")
    mkdir("anim2")
end

# Define the start and end positions of the center of the radial background
start_pos = [1, 1]
end_pos = [img_width, img_height]

# Generate a new radial background for each frame and save it as a PNG file
output_image = zeros(RGB{Float64}, img_height, img_width)

for i = 1:num_frames
    # Calculate the current position of the center based on the start and end positions
    current_pos = start_pos + (end_pos - start_pos) * (i - 1) / (num_frames - 1)

    # Create a matrix of RGB values with radial dependence based on distance from the center
    max_distance = sqrt((img_width / 2)^2 + (img_height / 2)^2)
    for x = 1:img_width, y = 1:img_height
        distance = sqrt((x - current_pos[1])^2 + (y - current_pos[2])^2)
        red = sin(i * frame_delta + distance / max_distance) / 2 + 0.5
        green = sin(i * frame_delta + distance / max_distance + 2 * pi / 3) / 2 + 0.5
        blue = sin(i * frame_delta + distance / max_distance + 4 * pi / 3) / 2 + 0.5
        output_image[y, x] = RGB(red, green, blue)
    end

    # Save the output image as a PNG file
    filename = "anim2/frame_" * string(i) * ".png"
    save(filename, output_image)

    # Print a progress message
    print("Frame ", i, "/", num_frames, "\r")
    flush(stdout)
end

# Use ffmpeg to generate a video from the PNG files
frame_rate = 30
run(`ffmpeg -n -r $frame_rate -f image2 -s $(img_width)x$(img_height) -i anim2/frame_%d.png -vcodec libx264 -crf 25 -pix_fmt yuv420p -n wave_animation5.mp4`)
