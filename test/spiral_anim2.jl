using Images
  
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
function generate_frame(output_image, i, center)
    # Create a matrix of RGB values with radial dependence based on distance from the center
    max_distance = sqrt(center[1]^2 + center[2]^2)
    for x = 1:img_width, y = 1:img_height
        distance = sqrt((x - center[1])^2 + (y - center[2])^2)
        red = sin(i * frame_delta + distance / max_distance) / 2 + 0.5
        green = sin(i * frame_delta + distance / max_distance + 2 * pi / 3) / 2 + 0.5
        blue = sin(i * frame_delta + distance / max_distance + 4 * pi / 3) / 2 + 0.5
        output_image[y, x] = RGB(red, green, blue)
    end
    output_image
end

# Set the initial center position randomly
center = [rand(1:img_width), rand(1:img_height)]

for i = 1:num_frames
    # Update the center position with a random walk
    center .+= 25 .* [rand([-1,0,1]), rand([-1,0,1])]
    # Generate the frame with the updated center position
    generate_frame(output_image, i, center)
    filename = "anim2/frame_" * string(i) * ".png"
    save(filename, output_image)
    print("Frame ", i, "/", num_frames, "\r")
    flush(stdout)
end

# run(`ffmpeg -r $frame_rate -f image2 -s $(img_width)x$(img_height) -i anim2/frame_%d.png -vcodec libx264 -crf 25 -pix_fmt yuv420p wave_animation4.mp4`)