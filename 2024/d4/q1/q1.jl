
xmasString = "XMAS"

function checkXmas(matrix, startx, starty, dx, dy)
    width = length(matrix[1])
    height = length(matrix)

    maxOffsetX = startx + (dx * 3)
    maxOffsetY = starty + (dy * 3)

    if (dx == 0 && dy == 0) || maxOffsetX > width || maxOffsetY > height || maxOffsetX < 1 || maxOffsetY < 1
        return false
    end

    for i in 1:3
        if matrix[starty + (dy * i)][startx + (dx * i)][1] != xmasString[i+1]
            return false
        end
    end

    return true
end

function main()
    f = open("in.q1.txt", "r")

    # create a 2d matrix
    matrix = []

    for line in eachline(f)
        push!(matrix, split(line, ""))
    end

    xmasCount = 0

    for starty in eachindex(matrix)
        for startx in eachindex(matrix[starty])
            if matrix[starty][startx] == "X"
                for dx in -1:1
                    for dy in -1:1
                        if checkXmas(matrix, startx, starty, dx, dy)
                            xmasCount += 1
                        end
                    end
                end
            end
        end
    end

    println(xmasCount)

    close(f)

end

main()